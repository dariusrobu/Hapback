//
//  LocalPlaylistService.swift
//  Hapback
//
//  Created by Conductor on 06.02.2026.
//

import Foundation

struct LocalPlaylistData: Codable {
    let id: String
    let title: String
    let songIds: [String]
}

class LocalPlaylistService {
    private let fileName = "user_playlists.json"
    
    private var playlistsData: [LocalPlaylistData] = []
    
    init() {
        loadPlaylists()
    }
    
    private func getFileURL() -> URL? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsURL.appendingPathComponent(fileName)
    }
    
    func loadPlaylists() {
        guard let url = getFileURL(),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([LocalPlaylistData].self, from: data) else {
            return
        }
        self.playlistsData = decoded
    }
    
    func savePlaylists() {
        guard let url = getFileURL(),
              let data = try? JSONEncoder().encode(playlistsData) else {
            return
        }
        try? data.write(to: url)
    }
    
    func createPlaylist(title: String) {
        let newPlaylist = LocalPlaylistData(id: UUID().uuidString, title: title, songIds: [])
        playlistsData.append(newPlaylist)
        savePlaylists()
    }
    
    func addSong(to playlistId: String, songId: String) {
        if let index = playlistsData.firstIndex(where: { $0.id == playlistId }) {
            let playlist = playlistsData[index]
            if !playlist.songIds.contains(songId) {
                var newIds = playlist.songIds
                newIds.append(songId)
                playlistsData[index] = LocalPlaylistData(id: playlist.id, title: playlist.title, songIds: newIds)
                savePlaylists()
            }
        }
    }
    
    func getLocalPlaylists(allSongs: [Song]) -> [Playlist] {
        return playlistsData.map { data in
            let playlistSongs = allSongs.filter { data.songIds.contains($0.id) }
            return Playlist(id: data.id, title: data.title, songs: playlistSongs)
        }
    }
}
