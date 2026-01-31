//
//  BrickGameViewModel.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import SwiftUI
import Combine

struct Brick: Identifiable {
    let id = UUID()
    var rect: CGRect
    var isDestroyed: Bool = false
}

@MainActor
class BrickGameViewModel: ObservableObject {
    @Published var paddleX: CGFloat = 0.5 // 0.0 to 1.0
    @Published var ballPosition: CGPoint = CGPoint(x: 0.5, y: 0.8)
    @Published var bricks: [Brick] = []
    @Published var score: Int = 0
    @Published var lives: Int = 3
    @Published var isGameOver = false
    @Published var isPaused = true
    
    private var ballVelocity = CGPoint(x: 0.005, y: -0.005)
    private var timer: Timer?
    private let brickRows = 5
    private let brickCols = 8
    
    init() {
        resetBricks()
    }
    
    func resetBricks() {
        bricks = []
        let width: CGFloat = 1.0 / CGFloat(brickCols)
        let height: CGFloat = 0.04
        
        for row in 0..<brickRows {
            for col in 0..<brickCols {
                let rect = CGRect(x: CGFloat(col) * width, y: CGFloat(row) * height + 0.1, width: width, height: height)
                bricks.append(Brick(rect: rect))
            }
        }
    }
    
    func startGame() {
        isPaused = false
        isGameOver = false
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.update()
            }
        }
    }
    
    func togglePause() {
        if isPaused {
            if isGameOver {
                resetGame()
            }
            startGame()
        } else {
            isPaused = true
            timer?.invalidate()
            timer = nil
        }
    }
    
    func resetGame() {
        score = 0
        lives = 3
        isGameOver = false
        isPaused = true
        ballPosition = CGPoint(x: 0.5, y: 0.8)
        ballVelocity = CGPoint(x: 0.005, y: -0.005)
        paddleX = 0.5
        resetBricks()
    }
    
    func movePaddle(delta: CGFloat) {
        paddleX = max(0.1, min(0.9, paddleX + delta))
    }
    
    private func update() {
        guard !isPaused && !isGameOver else { return }
        
        // Update position
        ballPosition.x += ballVelocity.x
        ballPosition.y += ballVelocity.y
        
        // Wall collisions
        if ballPosition.x <= 0 || ballPosition.x >= 1.0 {
            ballVelocity.x *= -1
        }
        if ballPosition.y <= 0 {
            ballVelocity.y *= -1
        }
        
        // Paddle collision
        let paddleWidth: CGFloat = 0.2
        if ballPosition.y >= 0.9 && ballPosition.y <= 0.92 {
            if ballPosition.x >= (paddleX - paddleWidth/2) && ballPosition.x <= (paddleX + paddleWidth/2) {
                ballVelocity.y *= -1
                // Add spin based on where it hit the paddle
                let hitOffset = (ballPosition.x - paddleX) / (paddleWidth/2)
                ballVelocity.x = hitOffset * 0.01
            }
        }
        
        // Brick collisions
        for i in 0..<bricks.count {
            if !bricks[i].isDestroyed && bricks[i].rect.contains(ballPosition) {
                bricks[i].isDestroyed = true
                ballVelocity.y *= -1
                score += 10
                break
            }
        }
        
        // Death
        if ballPosition.y >= 1.0 {
            lives -= 1
            if lives <= 0 {
                isGameOver = true
                isPaused = true
                timer?.invalidate()
            } else {
                ballPosition = CGPoint(x: 0.5, y: 0.8)
                ballVelocity = CGPoint(x: 0.005, y: -0.005)
                isPaused = true
                timer?.invalidate()
            }
        }
    }
}
