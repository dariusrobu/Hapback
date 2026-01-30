//
//  MenuItem.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation

enum MenuDestination {
    case playlists
    case artists
    case albums
    case songs
    case extras
    case settings
    case nowPlaying
    case unknown
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
