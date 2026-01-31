//
//  StopwatchViewModel.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import Combine

@MainActor
class StopwatchViewModel: ObservableObject {
    @Published var time: TimeInterval = 0
    @Published var isRunning = false
    
    private var timer: Timer?
    private var startTime: Date?
    private var accumulatedTime: TimeInterval = 0
    
    func toggle() {
        if isRunning {
            stop()
        } else {
            start()
        }
    }
    
    func start() {
        guard !isRunning else { return }
        isRunning = true
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            guard let self = self, let start = self.startTime else { return }
            Task { @MainActor in
                self.time = self.accumulatedTime + Date().timeIntervalSince(start)
            }
        }
    }
    
    func stop() {
        guard isRunning else { return }
        isRunning = false
        if let start = startTime {
            accumulatedTime += Date().timeIntervalSince(start)
        }
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        stop()
        accumulatedTime = 0
        time = 0
    }
    
    var formattedTime: String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let hundredths = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }
}
