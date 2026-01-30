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
                    gradient: Gradient(colors: [Color.white, Color(white: 0.94), Color(white: 0.90)]),
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
                                    .font(.system(size: 12))
                                Spacer()
                                Text("SONGS")
                                    .font(.system(size: 16, weight: .bold))
                                Spacer()
                                Image(systemName: "battery.75")
                                    .font(.system(size: 14))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.4))
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color.black.opacity(0.1)),
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
                                    withAnimation {
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
                        .cornerRadius(4)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                        .padding(.top, 40)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                    .frame(height: outerGeometry.size.height * 0.5)
                    
                    // Wheel Area (Bottom 50%)
                    ZStack {
                        ClickWheelView { direction in
                            handleRotation(direction)
                        }
                        .frame(width: 300, height: 300)
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
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(isSelected ? .white : .black)
            Spacer()
            if isSelected {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
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