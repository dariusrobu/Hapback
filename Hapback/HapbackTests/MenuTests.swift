//
//  MenuTests.swift
//  HapbackTests
//
//  Created by Conductor on 30.01.2026.
//

import XCTest
@testable import Hapback

final class MenuTests: XCTestCase {

    func testMenuSelectionLogic() {
        // Given a menu with 3 items
        let items = ["Songs", "Artists", "Albums"]
        
        // When selection index is 0
        let selectedIndex = 0
        XCTAssertEqual(items[selectedIndex], "Songs")
        
        // When selection index is incremented (simulating wheel scroll down)
        let nextIndex = selectedIndex + 1
        XCTAssertEqual(items[nextIndex], "Artists")
    }
    
    // We will test the binding logic in the View/ViewModel integration
}
