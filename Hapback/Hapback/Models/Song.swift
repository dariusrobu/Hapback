//
//  Song.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import MediaPlayer

struct Song: Identifiable {
    let id: MPMediaEntityPersistentID
    let title: String
    let artist: String
    let albumTitle: String
    let artwork: MPMediaItemArtwork?
    let mediaItem: MPMediaItem
    
    @MainActor
    init(from mediaItem: MPMediaItem) {
        self.id = mediaItem.persistentID
        self.title = mediaItem.title ?? "Unknown Title"
        self.artist = mediaItem.artist ?? "Unknown Artist"
        self.albumTitle = mediaItem.albumTitle ?? "Unknown Album"
        self.artwork = mediaItem.artwork
        self.mediaItem = mediaItem
    }
}
