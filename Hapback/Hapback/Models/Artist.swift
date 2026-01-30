//
//  Artist.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import MediaPlayer

struct Artist: Identifiable {
    let id: MPMediaEntityPersistentID
    let name: String
    let artwork: MPMediaItemArtwork?
    
    init(from mediaItemCollection: MPMediaItemCollection) {
        self.id = mediaItemCollection.representativeItem?.artistPersistentID ?? 0
        self.name = mediaItemCollection.representativeItem?.artist ?? "Unknown Artist"
        self.artwork = mediaItemCollection.representativeItem?.artwork
    }
}
