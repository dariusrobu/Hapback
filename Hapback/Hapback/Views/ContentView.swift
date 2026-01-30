//
//  ContentView.swift
//  Hapback
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        GeometryReader { outerGeometry in
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Display Area (Top 40%)
                    VStack {
                        Spacer()
                        Text("Hapback")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("iPod Classic (6th Gen) Experience")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(height: outerGeometry.size.height * 0.4)
                    
                    // Wheel Area (Bottom 60%)
                    ZStack {
                        // Background for the wheel area
                        Color.black
                        
                        ClickWheelView()
                            .frame(width: min(outerGeometry.size.width, outerGeometry.size.height * 0.6) * 0.85)
                    }
                    .frame(height: outerGeometry.size.height * 0.6)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}