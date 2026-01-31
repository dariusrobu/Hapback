//
//  BrickGameView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct BrickGameView: View {
    @ObservedObject var viewModel: BrickGameViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Text("Brick")
                    .font(.system(size: 14, weight: .bold))
                Spacer()
                Text("Score: \(viewModel.score)")
                    .font(.system(size: 14, weight: .bold))
                Spacer()
                HStack(spacing: 2) {
                    ForEach(0..<viewModel.lives, id: \.self) { _ in
                        Image(systemName: "heart.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.5))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.black.opacity(0.1)),
                alignment: .bottom
            )
            
            // Game Area
            GeometryReader { geometry in
                ZStack {
                    // Bricks
                    ForEach(viewModel.bricks) { brick in
                        if !brick.isDestroyed {
                            Rectangle()
                                .fill(Color(red: 0, green: 0, blue: 128/255))
                                .border(Color.white.opacity(0.2), width: 1)
                                .frame(width: brick.rect.width * geometry.size.width, height: brick.rect.height * geometry.size.height)
                                .position(x: brick.rect.midX * geometry.size.width, y: brick.rect.midY * geometry.size.height)
                        }
                    }
                    
                    // Ball
                    Circle()
                        .fill(Color.black)
                        .frame(width: 10, height: 10)
                        .position(x: viewModel.ballPosition.x * geometry.size.width, y: viewModel.ballPosition.y * geometry.size.height)
                    
                    // Paddle
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 0.2 * geometry.size.width, height: 10)
                        .position(x: viewModel.paddleX * geometry.size.width, y: 0.91 * geometry.size.height)
                    
                    if viewModel.isPaused {
                        VStack(spacing: 10) {
                            Text(viewModel.isGameOver ? "GAME OVER" : "PAUSED")
                                .font(.system(size: 32, weight: .black))
                                .foregroundColor(.red)
                            
                            Text("Press Center to \(viewModel.isGameOver ? "Restart" : "Resume")")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .position(x: geometry.size.width/2, y: geometry.size.height/2)
                    }
                }
            }
            .background(Color(red: 216/255, green: 233/255, blue: 240/255))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    BrickGameView(viewModel: BrickGameViewModel())
}
