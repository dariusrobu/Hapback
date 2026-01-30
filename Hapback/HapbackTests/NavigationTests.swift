//
//  NavigationTests.swift
//  HapbackTests
//
//  Created by Conductor on 30.01.2026.
//

import XCTest
@testable import Hapback
import SwiftUI

final class NavigationTests: XCTestCase {

    func testPlaceholderViewsExistence() {
        // Just verify that the placeholder views we are about to create exist
        // This test will fail initially because the views don't exist
        let playlists = PlaylistsView()
        let artists = ArtistsView()
        let albums = AlbumsView()
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
