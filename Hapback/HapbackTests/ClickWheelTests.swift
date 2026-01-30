//
//  ClickWheelTests.swift
//  HapbackTests
//
//  Created by Conductor on 30.01.2026.
//

import XCTest
@testable import Hapback

@MainActor
final class ClickWheelTests: XCTestCase {

    func testAngleCalculationFromCenter() {
        // Given a center point (150, 150)
        let center = CGPoint(x: 150, y: 150)
        let viewModel = ClickWheelViewModel()
        
        // When checking a point at (150, 50) - Top (12 o'clock)
        // In standard atan2, (0, -100) -> -pi/2 (-90 deg)
        let topPoint = CGPoint(x: 150, y: 50)
        let angleTop = viewModel.angle(for: topPoint, in: CGSize(width: 300, height: 300))
        
        // When checking a point at (250, 150) - Right (3 o'clock)
        // In standard atan2, (100, 0) -> 0 (0 deg)
        let rightPoint = CGPoint(x: 250, y: 150)
        let angleRight = viewModel.angle(for: rightPoint, in: CGSize(width: 300, height: 300))

        // We expect our ViewModel to normalize or handle these raw angles.
        // Let's assume standard geometric degrees for now where 0 is right.
        XCTAssertEqual(angleRight, 0, accuracy: 0.01)
        XCTAssertEqual(angleTop, -90, accuracy: 0.01)
    }
}
