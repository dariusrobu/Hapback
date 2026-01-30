//
//  HomeUITests.swift
//  HapbackTests
//
//  Created by Conductor on 30.01.2026.
//

import XCTest
@testable import Hapback
import SwiftUI

@MainActor
final class HomeUITests: XCTestCase {

    func testContentViewInitialization() {
        // Basic check to ensure ContentView initializes
        let view = ContentView()
        XCTAssertNotNil(view)
    }
}