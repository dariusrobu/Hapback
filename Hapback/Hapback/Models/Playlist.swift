//
//  Playlist.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import MediaPlayer

struct Playlist: Identifiable {
    let id: MPMediaEntityPersistentID
    let title: String
    let isSmart: Bool
    let items: [MPMediaItem]
    
    init(from mediaPlaylist: MPMediaPlaylist) {
        self.id = mediaPlaylist.persistentID
        self.title = mediaPlaylist.name ?? "Unknown Playlist"
        // Check if it's a smart playlist. 
        // MPMediaPlaylistAttributeSmart is bit 0.
        self.isSmart = mediaPlaylist.playlistAttributes.contains(.smart)
        self.items = mediaPlaylist.items
    }
}
