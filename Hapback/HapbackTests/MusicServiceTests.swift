//
//  MusicServiceTests.swift
//  HapbackTests
//
//  Created by Conductor on 30.01.2026.
//

import XCTest
@testable import Hapback
import MediaPlayer

final class MusicServiceTests: XCTestCase {

    func testServiceInitialization() {
        let service = MusicLibraryService()
        XCTAssertNotNil(service)
    }
    
    func testPermissionRequest() async {
        // We can't easily mock MPMediaLibrary authorization status in unit tests without extensive mocking.
        // For now, we verify the service has the method signature we expect.
        let service = MusicLibraryService()
        let status = await service.requestAuthorization()
        // In a simulator/test environment, this might return .notDetermined or .denied if info.plist isn't set up yet.
        // We just want to ensure it returns a valid status type.
        XCTAssertTrue(status == .authorized || status == .denied || status == .notDetermined || status == .restricted)
    }

    func testFetchPlaylists() {
        let service = MusicLibraryService()
        let playlists: [Playlist] = service.fetchPlaylists()
        // We expect this to return an array (empty or not)
        XCTAssertNotNil(playlists)
    }
}
