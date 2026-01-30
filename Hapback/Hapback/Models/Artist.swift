//
//  Artist.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import MediaPlayer
import UIKit

struct Artist: Identifiable {
    let id: String
    let name: String
    let artwork: UIImage?
    
    @MainActor
    init(from mediaItemCollection: MPMediaItemCollection) {
        self.id = String(mediaItemCollection.representativeItem?.artistPersistentID ?? 0)
        self.name = mediaItemCollection.representativeItem?.artist ?? "Unknown Artist"
        self.artwork = mediaItemCollection.representativeItem?.artwork?.image(at: CGSize(width: 600, height: 600))
    }
    
    init(id: String, name: String, artwork: UIImage?) {
        self.id = id
        self.name = name
        self.artwork = artwork
    }
}