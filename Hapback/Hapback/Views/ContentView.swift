//
//  ContentView.swift
//  Hapback
//

import SwiftUI
import SwiftData

//
//  ContentView.swift
//  Hapback
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedIndex = 0
    let menuItems = ["Bohemian Rhapsody", "Come Together", "Stairway to Heaven", "Starman", "Time"]
    
    var body: some View {
        GeometryReader { outerGeometry in
            ZStack {
                // Glossy Polycarbonate Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color(white: 0.96), Color(white: 0.92)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Display Area (Top 50%)
                    VStack {
                        // LCD Screen Container
                        VStack(spacing: 0) {
                            // Header Bar
                            HStack {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 10))
                                Spacer()
                                Text("SONGS")
                                    .font(.system(size: 14, weight: .bold))
                                    .kerning(-0.5)
                                Spacer()
                                Image(systemName: "battery.75")
                                    .font(.system(size: 12))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.5))
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color.black.opacity(0.15)),
                                alignment: .bottom
                            )
                            
                            // List Content
                            ScrollViewReader { proxy in
                                ScrollView(showsIndicators: false) {
                                    VStack(spacing: 0) {
                                        ForEach(0..<menuItems.count, id: \.self) { index in
                                            ListItem(text: menuItems[index], isSelected: index == selectedIndex)
                                                .id(index)
                                        }
                                    }
                                }
                                .onChange(of: selectedIndex) { newIndex in
                                    withAnimation(.linear(duration: 0.1)) {
                                        proxy.scrollTo(newIndex, anchor: .center)
                                    }
                                }
                            }
                        }
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 240/255, green: 248/255, blue: 1.0), Color(red: 230/255, green: 240/255, blue: 1.0)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(6)
                        // LCD Inner Shadow
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.black.opacity(0.1), lineWidth: 4)
                                .blur(radius: 4)
                                .offset(x: 0, y: 2)
                                .mask(RoundedRectangle(cornerRadius: 6))
                        )
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding(.top, 50)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .frame(height: outerGeometry.size.height * 0.5)
                    
                    // Wheel Area (Bottom 50%)
                    ZStack {
                        ClickWheelView { direction in
                            handleRotation(direction)
                        }
                        .frame(width: 280, height: 300)
                    }
                    .frame(height: outerGeometry.size.height * 0.5)
                }
            }
        }
    }
    
    private func handleRotation(_ direction: Int) {
        let newIndex = selectedIndex + direction
        if newIndex >= 0 && newIndex < menuItems.count {
            selectedIndex = newIndex
        }
    }
}

struct ListItem: View {
    let text: String
    var isSelected: Bool = false
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 18, weight: .bold))
                .kerning(-0.5)
                .foregroundColor(isSelected ? .white : .black)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(isSelected ? Color(red: 0, green: 0, blue: 128/255) : Color.clear)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.black.opacity(0.05)),
            alignment: .bottom
        )
    }
}

#Preview {
    ContentView()
}

#Preview {
    ContentView()
}