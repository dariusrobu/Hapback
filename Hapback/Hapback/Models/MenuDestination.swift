//
//  MenuDestination.swift
//  Hapback
//
//  Created by Conductor on 06.02.2026.
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
    case playlistDetail(Playlist) // Added this line
    case clock
    case games
    case stopwatch
    case calendars
    case brick
    case unknown
    
    static func == (lhs: MenuDestination, rhs: MenuDestination) -> Bool {
        switch (lhs, rhs) {
        case (.playlists, .playlists), (.artists, .artists), (.albums, .albums), (.songs, .songs), (.extras, .extras), (.settings, .settings), (.nowPlaying, .nowPlaying), (.clock, .clock), (.games, .games), (.stopwatch, .stopwatch), (.calendars, .calendars), (.brick, .brick), (.unknown, .unknown):
            return true
        case (.artistDetail(let a), .artistDetail(let b)):
            return a.id == b.id
        case (.albumDetail(let a), .albumDetail(let b)):
            return a.id == b.id
        case (.playlistDetail(let a), .playlistDetail(let b)):
            return a.id == b.id
        default:
            return false
        }
    }
}
