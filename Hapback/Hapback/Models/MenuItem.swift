//
//  MenuItem.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation

enum MenuDestination: Equatable {
    case playlists
    case artists
    case albums
    case songs
    case extras
    case settings
    case nowPlaying
    case artistDetail(Artist)
    case albumDetail(Album)
    case unknown
    
    static func == (lhs: MenuDestination, rhs: MenuDestination) -> Bool {
        switch (lhs, rhs) {
        case (.playlists, .playlists), (.artists, .artists), (.albums, .albums), (.songs, .songs), (.extras, .extras), (.settings, .settings), (.nowPlaying, .nowPlaying), (.unknown, .unknown):
            return true
        case (.artistDetail(let a), .artistDetail(let b)):
            return a.id == b.id
        case (.albumDetail(let a), .albumDetail(let b)):
            return a.id == b.id
        default:
            return false
        }
    }
}

struct MenuItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let destination: MenuDestination
}

struct MenuData {
    static let mainMenuItems: [MenuItem] = [
        MenuItem(title: "Playlists", icon: "music.note.list", destination: .playlists),
        MenuItem(title: "Artists", icon: "music.mic", destination: .artists),
        MenuItem(title: "Albums", icon: "square.stack", destination: .albums),
        MenuItem(title: "Songs", icon: "music.note", destination: .songs),
        MenuItem(title: "Extras", icon: "star", destination: .extras),
        MenuItem(title: "Settings", icon: "gear", destination: .settings),
        MenuItem(title: "Now Playing", icon: "play.circle", destination: .nowPlaying)
    ]
}