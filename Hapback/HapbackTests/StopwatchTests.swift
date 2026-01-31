//
//  StopwatchTests.swift
//  HapbackTests
//
//  Created by Conductor on 30.01.2026.
//

import XCTest
@testable import Hapback

@MainActor
final class StopwatchTests: XCTestCase {

    func testStopwatchInitialization() {
        let viewModel = StopwatchViewModel()
        XCTAssertEqual(viewModel.time, 0)
        XCTAssertFalse(viewModel.isRunning)
    }
    
    func testStopwatchToggle() {
        let viewModel = StopwatchViewModel()
        viewModel.toggle()
        XCTAssertTrue(viewModel.isRunning)
        viewModel.toggle()
        XCTAssertFalse(viewModel.isRunning)
    }
    
    func testStopwatchReset() {
        let viewModel = StopwatchViewModel()
        viewModel.start()
        viewModel.stop()
        viewModel.reset()
        XCTAssertEqual(viewModel.time, 0)
        XCTAssertFalse(viewModel.isRunning)
    }
}
