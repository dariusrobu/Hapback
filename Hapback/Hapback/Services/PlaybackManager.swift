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
            print("DEBUG: Re-asserting audio session activity for background")
            try? AVAudioSession.sharedInstance().setActive(true)
            self?.updateNowPlayingInfo()
        }
    }
    
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] event in
            self?.togglePlayPause()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { [weak self] event in
            self?.pause()
            return .success
        }
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget { [weak self] event in
            self?.skipForward()
            return .success
        }
        
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget { [weak self] event in
            self?.skipBackward()
            return .success
        }
    }
    
    private func setupAudioSession() {
        do {
            // Disable mixWithOthers by not including it in options. Using .longFormAudio policy.
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longFormAudio, options: [.allowBluetooth, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
            
            // Tell the application to start receiving remote control events
            UIApplication.shared.beginReceivingRemoteControlEvents()
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    private func setupInterruptionObserver() {
        NotificationCenter.default.addObserver(
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
        
        print("DEBUG: Starting playback for \(song.title) in background-ready mode")
        
        // Start a short background task to bridge the gap
        self.backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "HapbackPlayback") { [weak self] in
            print("DEBUG: Background task expired")
            if let task = self?.backgroundTask {
                UIApplication.shared.endBackgroundTask(task)
                self?.backgroundTask = .invalid
            }
        }
        
        // Explicitly set category and active for background support with longFormAudio policy
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, policy: .longFormAudio, options: [.allowBluetooth, .allowAirPlay])
            try session.setActive(true)
        } catch {
            print("ERROR: Failed to activate background audio session: \(error)")
        }
        
        // Stop current if any
        player?.pause()
        removeTimeObserver()
        
        // Cleanup old observers
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        guard let url = song.fileURL else {
            print("ERROR: Song has no URL for playback")
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            return
        }
        
        // Use precise duration key to prevent initialization hangs
        let asset = AVURLAsset(url: url, options: [AVURLAssetPreferPreciseDurationKey: true])
        let playerItem = AVPlayerItem(asset: asset)
        
        if player == nil {
            player = AVQueuePlayer(playerItem: playerItem)
            player?.allowsExternalPlayback = true
        } else {
            player?.replaceCurrentItem(with: playerItem)
        }
        
        currentSong = song
        // Reset time
        currentTime = 0
        
        // Duration from media item if available, otherwise from asset
        if let mediaItem = song.mediaItem {
            duration = mediaItem.playbackDuration
        } else {
            Task {
                if let duration = try? await asset.load(.duration) {
                    self.duration = duration.seconds
                    self.updateNowPlayingInfo()
                }
            }
        }
        
        updateNowPlayingInfo() // Call before play
        player?.play()
        player?.rate = 1.0 // Force rate to 1.0
        isPlaying = true
        
        addTimeObserver()
        
        // End the background task after a short delay once playback is confirmed
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            if let task = self?.backgroundTask, task != .invalid {
                UIApplication.shared.endBackgroundTask(task)
                self?.backgroundTask = .invalid
            }
        }
        
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
