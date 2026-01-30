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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Wheel Background
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                
                // Center Button
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.8), Color.gray]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: geometry.size.width * 0.35, height: geometry.size.width * 0.35)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                    )
                
                // Menu Buttons
                VStack {
                    Text("MENU")
                        .font(.custom("Helvetica Neue", size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .offset(y: -geometry.size.height * 0.35)
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "backward.end.alt.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .offset(x: -geometry.size.width * 0.35)
                        
                        Spacer()
                        
                        Image(systemName: "forward.end.alt.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .offset(x: geometry.size.width * 0.35)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "playpause.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .offset(y: geometry.size.height * 0.35)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let angle = viewModel.angle(for: value.location, in: geometry.size)
                        // In a real implementation, we would track delta rotation here
                        self.rotation = angle
                    }
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ClickWheelView()
            .frame(width: 300, height: 300)
    }
}
