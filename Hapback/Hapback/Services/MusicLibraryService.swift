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
    private let fileScanner = FileScannerService()
    
    func requestAuthorization() async -> MPMediaLibraryAuthorizationStatus {
        return await MPMediaLibrary.requestAuthorization()
    }
    
    func fetchSongs() async -> [Song] {
        let systemSongsQuery = MPMediaQuery.songs()
        let systemCollections = systemSongsQuery.items ?? []
        var songs: [Song] = []
        
        // Add system songs
        for item in systemCollections {
            songs.append(Song(from: item))
        }
        
        // Add local songs
        let localSongs = await fileScanner.scanDocumentsDirectory()
        songs.append(contentsOf: localSongs)
        
        return songs
    }
    
    func fetchAlbums() async -> [Album] {
        let query = MPMediaQuery.albums()
        let collections = query.collections ?? []
        var albums: [Album] = []
        
        // Add system albums
        for collection in collections {
            albums.append(Album(from: collection))
        }
        
        // Aggregate local albums
        let localSongs = await fileScanner.scanDocumentsDirectory()
        let localAlbumsGrouped = Dictionary(grouping: localSongs) { $0.albumTitle }
        
        for (albumTitle, songs) in localAlbumsGrouped {
            // Check if this album title already exists in system albums to avoid duplicates
            if !albums.contains(where: { $0.title == albumTitle }) {
                let firstSong = songs.first!
                let localAlbum = Album(
                    id: "local_album_\(albumTitle)",
                    title: albumTitle,
                    artist: firstSong.artist,
                    artwork: firstSong.artwork,
                    songs: songs
                )
                albums.append(localAlbum)
            }
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
        
        // Add system artists
        for collection in collections {
            artists.append(Artist(from: collection))
        }
        
        // Aggregate local artists
        let localSongs = await fileScanner.scanDocumentsDirectory()
        let localArtistsGrouped = Dictionary(grouping: localSongs) { $0.artist }
        
        for (artistName, songs) in localArtistsGrouped {
            if !artists.contains(where: { $0.name == artistName }) {
                let localArtist = Artist(
                    id: "local_artist_\(artistName)",
                    name: artistName,
                    artwork: songs.first?.artwork
                )
                artists.append(localArtist)
            }
        }
        
        return artists
    }
}
