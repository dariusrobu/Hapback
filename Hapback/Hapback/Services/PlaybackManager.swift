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
    
    private init() {
        setupAudioSession()
        setupInterruptionObserver()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.allowBluetooth, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
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
    
    func play(_ song: Song) {
        // Stop current if any
        player?.pause()
        removeTimeObserver()
        
        guard let url = song.fileURL else {
            print("Song has no URL for playback")
            return
        }
        
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        
        if player == nil {
            player = AVQueuePlayer(playerItem: playerItem)
        } else {
            player?.replaceCurrentItem(with: playerItem)
        }
        
        currentSong = song
        // Duration from media item if available, otherwise from asset
        if let mediaItem = song.mediaItem {
            duration = mediaItem.playbackDuration
        } else {
            // Task to load duration from asset if not available
            Task {
                if let duration = try? await asset.load(.duration) {
                    self.duration = duration.seconds
                }
            }
        }
        
        player?.play()
        isPlaying = true
        
        addTimeObserver()
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        
        if isPlaying {
            pause()
        } else {
            player.play()
            isPlaying = true
        }
    }
    
    func skipForward() {
        // Implement logic to skip to next in queue if implemented
    }
    
    func skipBackward() {
        // Implement logic to skip back or restart track
        player?.seek(to: .zero)
    }
    
    func adjustVolume(by delta: Double) {
        guard let player = player else { return }
        let currentVolume = Double(player.volume)
        let newVolume = max(0, min(1.0, currentVolume + delta))
        player.volume = Float(newVolume)
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            // Ensure mutation happens on main actor
            Task { @MainActor in
                self.currentTime = time.seconds
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
