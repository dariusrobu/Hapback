//
//  RotaryControlView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct RotaryControlView: View {
    @StateObject private var viewModel = ClickWheelViewModel()
    
    var onTick: ((Int) -> Void)?
    var onCenterPress: (() -> Void)?
    
    // Classic Design Constants
    private let wheelColor = Color(red: 245/255, green: 245/255, blue: 247/255) // --wheel-bg
    private let centerButtonColor = Color.white

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // The main wheel background
                Circle()
                    .fill(wheelColor)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.05), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 10)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: -2)

                // Center "Select" Button
                Button(action: {
                    onCenterPress?()
                }) {
                    ZStack {
                        Circle()
                            .fill(centerButtonColor)
                            .overlay(
                                Circle()
                                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: geometry.size.width * 0.32, height: geometry.size.width * 0.32)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // We don't need to show a rotation effect, just process the angle
                        _ = viewModel.angle(for: value.location, in: geometry.size)
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
        Color(white: 0.1)
        RotaryControlView()
            .frame(width: 250, height: 250)
    }
}

