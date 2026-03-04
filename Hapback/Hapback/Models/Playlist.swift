//
//  Playlist.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import MediaPlayer

struct Playlist: Identifiable {
    let id: String
    let title: String
    let isSmart: Bool
    let songs: [Song]
    
    @MainActor
    init(from mediaPlaylist: MPMediaPlaylist) {
        self.id = String(mediaPlaylist.persistentID)
        self.title = mediaPlaylist.name ?? "Unknown Playlist"
        self.isSmart = mediaPlaylist.playlistAttributes.contains(.smart)
        self.songs = mediaPlaylist.items.map { Song(from: $0) }
    }
    
    init(id: String, title: String, songs: [Song]) {
        self.id = id
        self.title = title
        self.isSmart = false
        self.songs = songs
    }
}
