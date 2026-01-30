//
//  Album.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import MediaPlayer

struct Album: Identifiable {
    let id: MPMediaEntityPersistentID
    let title: String
    let artist: String
    let artwork: MPMediaItemArtwork?
    let songs: [MPMediaItem]
    
    init(from mediaItemCollection: MPMediaItemCollection) {
        self.id = mediaItemCollection.representativeItem?.albumPersistentID ?? 0
        self.title = mediaItemCollection.representativeItem?.albumTitle ?? "Unknown Album"
        self.artist = mediaItemCollection.representativeItem?.artist ?? "Unknown Artist"
        self.artwork = mediaItemCollection.representativeItem?.artwork
        self.songs = mediaItemCollection.items
    }
}
