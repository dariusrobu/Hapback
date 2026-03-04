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
    private let localPlaylistService = LocalPlaylistService()
    
    func requestAuthorization() async -> MPMediaLibraryAuthorizationStatus {
        return await MPMediaLibrary.requestAuthorization()
    }
    
    func fetchSongs() async -> [Song] {
        let systemSongsQuery = MPMediaQuery.songs()
        let systemItems = systemSongsQuery.items ?? []
        var songs: [Song] = []
        
        // Add system songs
        for item in systemItems {
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
        // System Playlists
        let query = MPMediaQuery.playlists()
        let collections = query.collections ?? []
        var playlists: [Playlist] = []
        for collection in collections {
            if let mediaPlaylist = collection as? MPMediaPlaylist {
                playlists.append(Playlist(from: mediaPlaylist))
            }
        }
        
        // Local Playlists
        // We need all songs to resolve references
        let allSongs = await fetchSongs()
        let localPlaylists = localPlaylistService.getLocalPlaylists(allSongs: allSongs)
        
        playlists.append(contentsOf: localPlaylists)
        
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
    
    // Filtered Queries
    
    func fetchAlbums(for artist: Artist) async -> [Album] {
        // Fetch system albums for this artist
        let query = MPMediaQuery.albums()
        let predicate = MPMediaPropertyPredicate(value: artist.name, forProperty: MPMediaItemPropertyArtist)
        query.addFilterPredicate(predicate)
        let collections = query.collections ?? []
        var albums: [Album] = collections.map { Album(from: $0) }
        
        // Aggregate local albums for this artist
        let localSongs = await fileScanner.scanDocumentsDirectory()
        let artistLocalSongs = localSongs.filter { $0.artist == artist.name }
        let localAlbumsGrouped = Dictionary(grouping: artistLocalSongs) { $0.albumTitle }
        
        for (albumTitle, songs) in localAlbumsGrouped {
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
    
    func fetchSongs(for album: Album) async -> [Song] {
        // If it's a system album, we can use MPMediaQuery
        if !album.id.hasPrefix("local_album_") {
            let query = MPMediaQuery.songs()
            let predicate = MPMediaPropertyPredicate(value: album.title, forProperty: MPMediaItemPropertyAlbumTitle)
            query.addFilterPredicate(predicate)
            let items = query.items ?? []
            return items.map { Song(from: $0) }
        } else {
            // It's a local album, we already have the songs
            return album.songs
        }
    }
}