//
//  MenuTests.swift
//  HapbackTests
//
//  Created by Conductor on 30.01.2026.
//

import XCTest
@testable import Hapback

final class MenuModelTests: XCTestCase {

    func testMenuItemInitialization() {
        let item = MenuItem(title: "Songs", icon: "music.note", destination: .songs)
        XCTAssertEqual(item.title, "Songs")
        XCTAssertEqual(item.icon, "music.note")
        XCTAssertEqual(item.destination, .songs)
    }
    
    func testStaticDataSource() {
        let items = MenuData.mainMenuItems
        XCTAssertFalse(items.isEmpty)
        XCTAssertEqual(items[0].title, "Playlists")
        // Verify the order matches spec
        let titles = items.map { $0.title }
        let expected = ["Playlists", "Artists", "Albums", "Songs", "Extras", "Settings", "Now Playing"]
        XCTAssertEqual(titles, expected)
    }
}
