//
//  Item.swift
//  Hapback
//
//  Created by Robu Darius on 30.01.2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
