//
//  BrickGameView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct BrickGameView: View {
    @ObservedObject var viewModel: BrickGameViewModel
    
    // Theme Colors (LCD Style)
    let lcdTopColor = Color(red: 240/255, green: 248/255, blue: 1.0) // aliceblue
    let lcdBottomColor = Color(red: 230/255, green: 240/255, blue: 1.0)
    let primaryColor = Color(red: 0/255, green: 0/255, blue: 128/255) // Navy Blue
    let chicagoFont = Font.system(size: 16, weight: .bold)
    let chicagoFontLarge = Font.system(size: 28, weight: .bold)
    
    var body: some View {
        ZStack {
            // Screen background gradient
            LinearGradient(gradient: Gradient(colors: [lcdTopColor, lcdBottomColor]), startPoint: .top, endPoint: .bottom)
            
            VStack(spacing: 0) {
                // Game Header (Score and Lives)
                HStack {
                    Text("SCORE: \(viewModel.score)")
                        .font(chicagoFont)
                        .foregroundColor(.black.opacity(0.8))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { index in
                            Image(systemName: index < viewModel.lives ? "heart.fill" : "heart")
                                .font(.system(size: 12))
                                .foregroundColor(index < viewModel.lives ? primaryColor : .black.opacity(0.2))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.2))
                .border(width: 1, edges: [.bottom], color: .black.opacity(0.05))
                
                // Game Area
                GeometryReader { geometry in
                    ZStack {
                        // Bricks
                        ForEach(viewModel.bricks) { brick in
                            if !brick.isDestroyed {
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(primaryColor.opacity(0.9))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 1)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                                    )
                                    .frame(width: brick.rect.width * geometry.size.width - 2, height: brick.rect.height * geometry.size.height - 2)
                                    .position(x: brick.rect.midX * geometry.size.width, y: brick.rect.midY * geometry.size.height)
                                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                            }
                        }
                        
                        // Ball
                        Circle()
                            .fill(Color.black)
                            .frame(width: 10, height: 10)
                            .position(x: viewModel.ballPosition.x * geometry.size.width, y: viewModel.ballPosition.y * geometry.size.height)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                        
                        // Paddle
                        RoundedRectangle(cornerRadius: 2)
                            .fill(primaryColor)
                            .frame(width: 0.22 * geometry.size.width, height: 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .position(x: viewModel.paddleX * geometry.size.width, y: 0.92 * geometry.size.height)
                            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
                        
                        // Pause / Game Over Overlay
                        if viewModel.isPaused {
                            VStack(spacing: 16) {
                                Text(viewModel.isGameOver ? "GAME OVER" : "PAUSED")
                                    .font(chicagoFontLarge)
                                    .foregroundColor(.black)
                                    .tracking(1.0)
                                
                                Text(viewModel.isGameOver ? "PRESS CENTER TO RESTART" : "PRESS CENTER TO RESUME")
                                    .font(chicagoFont)
                                    .foregroundColor(.black.opacity(0.6))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.white.opacity(0.9))
                                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
                            )
                            .position(x: geometry.size.width/2, y: geometry.size.height/2)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    BrickGameView(viewModel: BrickGameViewModel())
}

