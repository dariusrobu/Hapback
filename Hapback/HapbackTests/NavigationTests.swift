//
//  NavigationTests.swift
//  HapbackTests
//
//  Created by Conductor on 30.01.2026.
//

import XCTest
@testable import Hapback
import SwiftUI

@MainActor
final class NavigationTests: XCTestCase {

    func testPlaceholderViewsExistence() {
        let playlists = PlaylistsView(selectedIndex: .constant(0), playlists: [])
        let artists = ArtistsView(selectedIndex: .constant(0), artists: [])
        let albums = AlbumsView(selectedIndex: .constant(0), albums: [])
        let songs = SongsView()
        let extras = ExtrasView()
        let settings = SettingsView()
        let nowPlaying = NowPlayingView()
        
        XCTAssertNotNil(playlists)
        XCTAssertNotNil(artists)
        XCTAssertNotNil(albums)
        XCTAssertNotNil(songs)
        XCTAssertNotNil(extras)
        XCTAssertNotNil(settings)
        XCTAssertNotNil(nowPlaying)
    }
}