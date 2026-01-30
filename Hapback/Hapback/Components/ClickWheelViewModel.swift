//
//  ClickWheelViewModel.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import CoreGraphics
import Combine

@MainActor
class ClickWheelViewModel: ObservableObject {
    
    /// Calculates the angle in degrees relative to the center of a given size.
    /// 0 degrees is at 3 o'clock, -90 degrees is at 12 o'clock.
    func angle(for point: CGPoint, in size: CGSize) -> Double {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let deltaX = point.x - center.x
        let deltaY = point.y - center.y
        
        let radians = atan2(deltaY, deltaX)
        return radians * 180 / .pi
    }
}
