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
    
    func fetchAlbums() async -> [Album] {
        return await Task.detached(priority: .userInitiated) {
            let query = MPMediaQuery.albums()
            let collections = query.collections ?? []
            return collections.map { Album(from: $0) }
        }.value
    }

    func fetchPlaylists() async -> [Playlist] {
        return await Task.detached(priority: .userInitiated) {
            let query = MPMediaQuery.playlists()
            let collections = query.collections ?? []
            return collections.compactMap { $0 as? MPMediaPlaylist }.map { Playlist(from: $0) }
        }.value
    }

    func fetchArtists() async -> [Artist] {
        return await Task.detached(priority: .userInitiated) {
            let query = MPMediaQuery.artists()
            let collections = query.collections ?? []
            return collections.map { Artist(from: $0) }
        }.value
    }
}
