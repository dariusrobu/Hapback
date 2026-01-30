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
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func play(_ song: Song) {
        // Stop current if any
        player?.pause()
        removeTimeObserver()
        
        guard let url = song.mediaItem.assetURL else {
            print("Song has no asset URL")
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
        duration = song.mediaItem.playbackDuration
        
        player?.play()
        isPlaying = true
        
        addTimeObserver()
    }
    
    func togglePlayPause() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying.toggle()
    }
    
    func skipForward() {
        // Implement logic to skip to next in queue if implemented
    }
    
    func skipBackward() {
        // Implement logic to skip back or restart track
        player?.seek(to: .zero)
    }
    
    func adjustVolume(by delta: Double) {
        let musicPlayer = MPMusicPlayerController.applicationMusicPlayer
        let currentVolume = musicPlayer.volume
        let newVolume = max(0, min(1.0, currentVolume + Float(delta)))
        musicPlayer.volume = newVolume
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
        }
    }
    
    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
}
