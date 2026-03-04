//
//  MediaControlsView.swift
//  Hapback
//
//  Created by Conductor on 06.02.2026.
//

import SwiftUI

struct MediaControlsView: View {
    var onMenuPress: () -> Void
    var onPrevPress: () -> Void
    var onNextPress: () -> Void
    var onPlayPausePress: () -> Void
    
    // Pro Audio Theme Colors
    private let buttonColor = Color(red: 40/255, green: 40/255, blue: 42/255)
    private let labelColor = Color(red: 200/255, green: 200/255, blue: 200/255)
    
    var body: some View {
        HStack(spacing: 20) {
            // MENU Button
            ControlButton(label: "MENU", icon: nil, action: onMenuPress)
            
            // PREV Button
            ControlButton(label: nil, icon: "backward.end.alt.fill", action: onPrevPress)
            
            // PLAY/PAUSE Button
            ControlButton(label: nil, icon: "playpause.fill", action: onPlayPausePress)
            
            // NEXT Button
            ControlButton(label: nil, icon: "forward.end.alt.fill", action: onNextPress)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.black.opacity(0.2))
        )
    }
}

struct ControlButton: View {
    let label: String?
    let icon: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Button physical shape
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(white: 0.25),
                                Color(white: 0.15)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 2)
                
                // Label or Icon
                if let label = label {
                    Text(label)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(white: 0.9))
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(Color(white: 0.9))
                }
            }
            .frame(height: 44) // Standard tactile button height
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PressableButtonStyle())
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ZStack {
        Color.black
        MediaControlsView(
            onMenuPress: {},
            onPrevPress: {},
            onNextPress: {},
            onPlayPausePress: {}
        )
    }
}
