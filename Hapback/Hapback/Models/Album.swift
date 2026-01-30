//
//  Album.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import MediaPlayer
import UIKit

struct Album: Identifiable {
    let id: String
    let title: String
    let artist: String
    let artwork: UIImage?
    let songs: [Song]
    
    @MainActor
    init(from mediaItemCollection: MPMediaItemCollection) {
        self.id = String(mediaItemCollection.representativeItem?.albumPersistentID ?? 0)
        self.title = mediaItemCollection.representativeItem?.albumTitle ?? "Unknown Album"
        self.artist = mediaItemCollection.representativeItem?.artist ?? "Unknown Artist"
        self.artwork = mediaItemCollection.representativeItem?.artwork?.image(at: CGSize(width: 600, height: 600))
        self.songs = mediaItemCollection.items.map { Song(from: $0) }
    }
    
    init(id: String, title: String, artist: String, artwork: UIImage?, songs: [Song]) {
        self.id = id
        self.title = title
        self.artist = artist
        self.artwork = artwork
        self.songs = songs
    }
}