//
//  PlaybackTests.swift
//  HapbackTests
//
//  Created by Conductor on 30.01.2026.
//

import XCTest
@testable import Hapback

@MainActor
final class PlaybackTests: XCTestCase {

    func testPlaybackManagerInitialization() {
        let manager = PlaybackManager.shared
        XCTAssertNotNil(manager)
        XCTAssertFalse(manager.isPlaying)
    }
    
    func testPauseState() {
        let manager = PlaybackManager.shared
        manager.pause()
        XCTAssertFalse(manager.isPlaying)
    }
}
