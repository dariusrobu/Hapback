//
//  PlaybackManager.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import AVFoundation
import MediaPlayer
import Combine

@MainActor
class PlaybackManager: ObservableObject {
    static let shared = PlaybackManager()
    
    private var player: AVQueuePlayer?
    private var timeObserver: Any?
    
    @Published var currentSong: Song?
    @Published var isPlaying = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    
    private var queue: [Song] = []
    private var currentIndex: Int = 0
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    private init() {
        setupAudioSession()
        setupInterruptionObserver()
        setupBackgroundObserver()
        setupRemoteCommandCenter()
    }
    
    private func setupBackgroundObserver() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                print("DEBUG: Re-asserting audio session activity for background")
                try? AVAudioSession.sharedInstance().setActive(true)
                self?.updateNowPlayingInfo()
            }
        }
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] event in
            if let self = self {
                Task { @MainActor in
                    self.togglePlayPause()
                }
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] event in
            if let self = self {
                Task { @MainActor in
                    self.pause()
                }
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { [weak self] event in
            if let self = self {
                Task { @MainActor in
                    self.skipForward()
                }
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { [weak self] event in
            if let self = self {
                Task { @MainActor in
                    self.skipBackward()
                }
                return .success
            }
            return .commandFailed
        }
    }
    
        private func setupAudioSession() {
            // Session is primarily managed by AppDelegate for early activation.
            do {
                let session = AVAudioSession.sharedInstance()
                // Using .playback without specific options to ensure standard behavior
                try session.setCategory(.playback, mode: .default, options: [.allowBluetoothA2DP, .allowAirPlay])
                try session.setActive(true)
                
                // Listen for route changes (e.g., headphones plugged/unplugged)
                NotificationCenter.default.addObserver(
                    forName: AVAudioSession.routeChangeNotification,
                    object: session,
                    queue: .main
                ) { notification in
                    print("DEBUG: Audio route changed: \(notification.userInfo ?? [:])")
                }
                
                UIApplication.shared.beginReceivingRemoteControlEvents()
            } catch {
                print("ERROR: Failed to refine audio session: \(error)")
            }
        }
    
        private func setupInterruptionObserver() {        NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance(),
            queue: .main
        ) { [weak self] notification in
            guard let userInfo = notification.userInfo,
                  let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
                  let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
            }
            
            if type == .began {
                // Interruption began, pause playback
                self?.pause()
            } else if type == .ended {
                if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                    let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                    if options.contains(.shouldResume) {
                        // User preference is manual resume (as per spec), so we don't auto-resume here.
                        // But we still update the state.
                    }
                }
            }
        }
    }
    
    func play(_ song: Song, in queue: [Song] = []) {
        if !queue.isEmpty {
            self.queue = queue
            self.currentIndex = queue.firstIndex(where: { $0.id == song.id }) ?? 0
        } else {
            self.queue = [song]
            self.currentIndex = 0
        }
        
        playCurrentIndex()
    }
    
    private func playCurrentIndex() {
        guard currentIndex >= 0 && currentIndex < queue.count else { return }
        let song = queue[currentIndex]
        
        print("DEBUG: Starting playback for \(song.title)")
        
        // Ensure audio session is active
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("ERROR: Failed to activate audio session: \(error)")
        }
        
        // Stop current if any
        player?.pause()
        removeTimeObserver()
        
        // Cleanup old observers
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        guard let url = song.fileURL else {
            print("ERROR: Song has no URL for playback")
            return
        }
        
        // Use basic initialization for maximum compatibility
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        if player == nil {
            player = AVQueuePlayer(playerItem: playerItem)
            player?.allowsExternalPlayback = true
        } else {
            player?.replaceCurrentItem(with: playerItem)
        }
        
        // Force volume settings and disable mute
        player?.volume = 1.0
        player?.isMuted = false
        
        currentSong = song
        // Reset time
        currentTime = 0
        
        // Duration from media item if available, otherwise from asset
        if let mediaItem = song.mediaItem {
            duration = mediaItem.playbackDuration
        } else {
            Task {
                // Using explicit property reference to avoid ambiguity
                let assetDuration = asset.duration
                let seconds = CMTimeGetSeconds(assetDuration)
                self.duration = seconds
                self.updateNowPlayingInfo()
            }
        }
        
        updateNowPlayingInfo() // Call before play
        
        // Final session activation check
        try? AVAudioSession.sharedInstance().setActive(true)
        
        player?.play()
        isPlaying = true
        
        addTimeObserver()
        
        // Observe end of item to auto-skip
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            print("DEBUG: Track ended, skipping forward")
            self?.skipForward()
        }
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
        updateNowPlayingInfo()
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        
        if isPlaying {
            pause()
        } else {
            player.play()
            isPlaying = true
            updateNowPlayingInfo()
        }
    }
    
    func skipForward() {
        if currentIndex < queue.count - 1 {
            currentIndex += 1
            playCurrentIndex()
        } else {
            // End of queue, just stop or loop
            pause()
            player?.seek(to: .zero)
        }
    }
    
    func skipBackward() {
        if currentTime > 3.0 {
            // Restart track if more than 3 seconds in
            player?.seek(to: .zero)
            currentTime = 0
            updateNowPlayingInfo()
        } else if currentIndex > 0 {
            currentIndex -= 1
            playCurrentIndex()
        } else {
            // Start of queue, just restart track
            player?.seek(to: .zero)
            currentTime = 0
            updateNowPlayingInfo()
        }
    }
    
    func adjustVolume(by delta: Double) {
        guard let player = player else { return }
        let currentVolume = Double(player.volume)
        let newVolume = max(0, min(1.0, currentVolume + delta))
        player.volume = Float(newVolume)
    }
    
    private func updateNowPlayingInfo() {
        guard let song = currentSong else {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
            return
        }
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = song.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = song.artist
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = song.albumTitle
        
        if let image = song.artwork {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player?.currentTime().seconds ?? 0
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            // Ensure mutation happens on main actor
            Task { @MainActor in
                self.currentTime = time.seconds
                
                // Update system info center every 10 seconds to keep it fresh
                if Int(self.currentTime) % 10 == 0 {
                    self.updateNowPlayingInfo()
                }
            }
        }
    }
    
    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
}
