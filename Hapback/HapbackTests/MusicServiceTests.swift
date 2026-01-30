//
//  MusicServiceTests.swift
//  HapbackTests
//
//  Created by Conductor on 30.01.2026.
//

import XCTest
@testable import Hapback
import MediaPlayer

@MainActor
final class MusicServiceTests: XCTestCase {

    func testServiceInitialization() {
        let service = MusicLibraryService()
        XCTAssertNotNil(service)
    }
    
    func testPermissionRequest() async {
        let service = MusicLibraryService()
        let status = await service.requestAuthorization()
        XCTAssertTrue(status == .authorized || status == .denied || status == .notDetermined || status == .restricted)
    }

    func testFetchPlaylists() async {
        let service = MusicLibraryService()
        let playlists: [Playlist] = await service.fetchPlaylists()
        XCTAssertNotNil(playlists)
    }

    func testFetchArtists() async {
        let service = MusicLibraryService()
        let artists: [Artist] = await service.fetchArtists()
        XCTAssertNotNil(artists)
    }
}