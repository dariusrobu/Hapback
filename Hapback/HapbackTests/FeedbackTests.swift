//
//  FeedbackTests.swift
//  HapbackTests
//
//  Created by Conductor on 30.01.2026.
//

import XCTest
@testable import Hapback

final class FeedbackTests: XCTestCase {

    func testHapticEngineInitialization() {
        // Just verify that we can instantiate the manager without crashing.
        // Core Haptics requires a real device to function fully, but we can check basic setup.
        let hapticManager = HapticManager()
        XCTAssertNotNil(hapticManager)
    }
    
    func testAudioManagerInitialization() {
        // Verify AudioManager initialization
        let audioManager = AudioManager()
        XCTAssertNotNil(audioManager)
    }
}
