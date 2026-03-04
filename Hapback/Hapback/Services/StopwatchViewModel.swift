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
    
    private var timerTask: Task<Void, Never>?
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
        
        // Cancel existing task if any
        timerTask?.cancel()
        
        timerTask = Task {
            while !Task.isCancelled {
                if let start = self.startTime {
                    self.time = self.accumulatedTime + Date().timeIntervalSince(start)
                }
                // Update roughly every 0.01 seconds
                try? await Task.sleep(nanoseconds: 10_000_000)
            }
        }
    }
    
    func stop() {
        guard isRunning else { return }
        isRunning = false
        if let start = startTime {
            accumulatedTime += Date().timeIntervalSince(start)
        }
        timerTask?.cancel()
        timerTask = nil
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