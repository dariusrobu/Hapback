//
//  MusicLibraryService.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import MediaPlayer

@MainActor
class MusicLibraryService {
    
    func requestAuthorization() async -> MPMediaLibraryAuthorizationStatus {
        return await MPMediaLibrary.requestAuthorization()
    }
    
    func fetchSongs() async -> [Song] {
        let query = MPMediaQuery.songs()
        let items = query.items ?? []
        var songs: [Song] = []
        for item in items {
            songs.append(Song(from: item))
        }
        return songs
    }
    
    func fetchAlbums() async -> [Album] {
        let query = MPMediaQuery.albums()
        let collections = query.collections ?? []
        var albums: [Album] = []
        for collection in collections {
            albums.append(Album(from: collection))
        }
        return albums
    }

    func fetchPlaylists() async -> [Playlist] {
        let query = MPMediaQuery.playlists()
        let collections = query.collections ?? []
        var playlists: [Playlist] = []
        for collection in collections {
            if let mediaPlaylist = collection as? MPMediaPlaylist {
                playlists.append(Playlist(from: mediaPlaylist))
            }
        }
        return playlists
    }

    func fetchArtists() async -> [Artist] {
        let query = MPMediaQuery.artists()
        let collections = query.collections ?? []
        var artists: [Artist] = []
        for collection in collections {
            artists.append(Artist(from: collection))
        }
        return artists
    }
}