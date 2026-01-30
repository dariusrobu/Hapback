//
//  ClickWheelView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct ClickWheelView: View {
    @StateObject private var viewModel = ClickWheelViewModel()
    @State private var rotation: Double = 0
    
    var onTick: ((Int) -> Void)?
    
    // Design constants from HTML
    private let wheelBackground = Color(red: 245/255, green: 245/255, blue: 247/255) // #f5f5f7
    private let iconColor = Color.gray.opacity(0.6) // gray-400 equivalent
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Wheel Background
                Circle()
                    .fill(wheelBackground)
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 2) // border-gray-200
                    )
                    .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 10) // click-wheel-shadow approx
                
                // Center Button (32% size)
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.white, Color(white: 0.98)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: geometry.size.width * 0.32, height: geometry.size.width * 0.32)
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                
                // Menu Text (Top 10%)
                VStack {
                    Text("MENU")
                        .font(.system(size: 14, weight: .bold))
                        .kerning(2.0) // tracking-[0.2em]
                        .foregroundColor(iconColor)
                        .padding(.top, geometry.size.height * 0.1)
                    Spacer()
                }
                
                // Play/Pause (Bottom 10%)
                VStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "play.fill")
                            .font(.system(size: 18))
                        Image(systemName: "pause.fill")
                            .font(.system(size: 18))
                    }
                    .foregroundColor(iconColor)
                    .padding(.bottom, geometry.size.height * 0.1)
                }
                
                // Rewind (Left 10%)
                HStack {
                    Image(systemName: "backward.end.alt.fill")
                        .font(.system(size: 22))
                        .foregroundColor(iconColor)
                        .padding(.leading, geometry.size.width * 0.1)
                    Spacer()
                }
                
                // Fast Forward (Right 10%)
                HStack {
                    Spacer()
                    Image(systemName: "forward.end.alt.fill")
                        .font(.system(size: 22))
                        .foregroundColor(iconColor)
                        .padding(.trailing, geometry.size.width * 0.1)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let angle = viewModel.angle(for: value.location, in: geometry.size)
                        self.rotation = angle
                    }
            )
            .onReceive(viewModel.tickPublisher) { direction in
                onTick?(direction)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    ZStack {
        Color(white: 0.95)
        ClickWheelView()
            .frame(width: 300, height: 300)
    }
}
