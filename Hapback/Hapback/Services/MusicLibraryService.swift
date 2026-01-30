//
//  MusicLibraryService.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import MediaPlayer

class MusicLibraryService {
    
    func requestAuthorization() async -> MPMediaLibraryAuthorizationStatus {
        return await MPMediaLibrary.requestAuthorization()
    }
    
    func fetchSongs() -> [MPMediaItem] {
        let query = MPMediaQuery.songs()
        return query.items ?? []
    }
    
    func fetchAlbums() -> [MPMediaItemCollection] {
        let query = MPMediaQuery.albums()
        return query.collections ?? []
    }

    func fetchPlaylists() -> [Playlist] {
        let query = MPMediaQuery.playlists()
        let collections = query.collections ?? []
        return collections.compactMap { $0 as? MPMediaPlaylist }.map { Playlist(from: $0) }
    }
}
