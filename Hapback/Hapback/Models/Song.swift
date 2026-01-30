//
//  Song.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import MediaPlayer
import AVFoundation

struct Song: Identifiable {
    let id: String // Use String ID for flexibility (UUID for local, persistentID for system)
    let title: String
    let artist: String
    let albumTitle: String
    let artwork: UIImage? // Use UIImage directly for local files, or a wrapper
    
    // Original sources for playback
    let mediaItem: MPMediaItem?
    let fileURL: URL?
    
    @MainActor
    init(from mediaItem: MPMediaItem) {
        self.id = String(mediaItem.persistentID)
        self.title = mediaItem.title ?? "Unknown Title"
        self.artist = mediaItem.artist ?? "Unknown Artist"
        self.albumTitle = mediaItem.albumTitle ?? "Unknown Album"
        self.artwork = mediaItem.artwork?.image(at: CGSize(width: 600, height: 600))
        self.mediaItem = mediaItem
        self.fileURL = mediaItem.assetURL
    }
    
    init(id: String, title: String, artist: String, albumTitle: String, artwork: UIImage?, fileURL: URL) {
        self.id = id
        self.title = title
        self.artist = artist
        self.albumTitle = albumTitle
        self.artwork = artwork
        self.mediaItem = nil
        self.fileURL = fileURL
    }
}