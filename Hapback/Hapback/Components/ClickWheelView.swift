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
    var onCenterPress: (() -> Void)?
    var onMenuPress: (() -> Void)?
    var onPlayPausePress: (() -> Void)?
    var onForwardPress: (() -> Void)?
    var onBackwardPress: (() -> Void)?
    
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
                    // Inset shadow simulation
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.05), lineWidth: 4)
                            .blur(radius: 4)
                            .offset(x: 0, y: 2)
                            .mask(Circle())
                    )
                    .shadow(color: .black.opacity(0.1), radius: 15, x: 0, y: 10)
                
                // Center Button (32% size)
                Button(action: {
                    onCenterPress?()
                }) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.white, Color(white: 0.95)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                        )
                        // Subtle inner shadow for the button
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.05), lineWidth: 2)
                                .blur(radius: 2)
                                .offset(x: 0, y: 1)
                                .mask(Circle())
                        )
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: geometry.size.width * 0.32, height: geometry.size.width * 0.32)
                .zIndex(20) // Ensure it's above the gesture area if needed, though gestures usually capture first
                
                // Menu Text (Top 10%)
                VStack {
                    Button(action: {
                        onMenuPress?()
                    }) {
                        Text("MENU")
                            .font(.system(size: 14, weight: .bold))
                            .kerning(2.0) // tracking-[0.2em]
                            .foregroundColor(iconColor)
                            .padding(.top, geometry.size.height * 0.1)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .zIndex(15)
                
                // Play/Pause (Bottom 10%)
                VStack {
                    Spacer()
                    Button(action: {
                        onPlayPausePress?()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 18))
                            Image(systemName: "pause.fill")
                                .font(.system(size: 18))
                        }
                        .foregroundColor(iconColor)
                        .padding(.bottom, geometry.size.height * 0.1)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .zIndex(15)
                
                // Rewind (Left 10%)
                HStack {
                    Button(action: {
                        onBackwardPress?()
                    }) {
                        Image(systemName: "backward.end.alt.fill")
                            .font(.system(size: 22))
                            .foregroundColor(iconColor)
                            .padding(.leading, geometry.size.width * 0.1)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .zIndex(15)
                
                // Fast Forward (Right 10%)
                HStack {
                    Spacer()
                    Button(action: {
                        onForwardPress?()
                    }) {
                        Image(systemName: "forward.end.alt.fill")
                            .font(.system(size: 22))
                            .foregroundColor(iconColor)
                            .padding(.trailing, geometry.size.width * 0.1)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .zIndex(15)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
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
