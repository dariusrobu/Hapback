//
//  ContentView.swift
//  Hapback
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedIndex = 0
    @State private var navigationStack: [MenuDestination] = []
    
    var currentDestination: MenuDestination {
        navigationStack.last ?? .unknown
    }
    
    var menuItems: [MenuItem] {
        let allItems = MenuData.mainMenuItems
        // Mock condition: Show "Now Playing" if isPlaying is true
        let isPlaying = true 
        if isPlaying {
            return allItems
        } else {
            return allItems.filter { $0.destination != .nowPlaying }
        }
    }
    
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
                            if navigationStack.isEmpty {
                                // Home Menu View
                                homeMenuView
                            } else {
                                // Sub-Menu or Content View
                                destinationView(for: currentDestination)
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
                        ClickWheelView(
                            onTick: { direction in
                                handleRotation(direction)
                            },
                            onCenterPress: {
                                handleCenterPress()
                            },
                            onMenuPress: {
                                handleMenuPress()
                            }
                        )
                        .frame(width: 280, height: 300)
                    }
                    .frame(height: outerGeometry.size.height * 0.5)
                }
            }
        }
    }
    
    private var homeMenuView: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Image(systemName: "play.fill")
                    .font(.system(size: 10))
                    .frame(width: 20, alignment: .leading)
                
                Spacer()
                Text("Hapback")
                    .font(.system(size: 14, weight: .bold))
                    .kerning(-0.5)
                Spacer()
                
                Image(systemName: "battery.75")
                    .font(.system(size: 12))
                    .frame(width: 20, alignment: .trailing)
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
                            ListItem(item: menuItems[index], isSelected: index == selectedIndex)
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
    }
    
    @ViewBuilder
    private func destinationView(for destination: MenuDestination) -> some View {
        VStack(spacing: 0) {
            // Sub-page Header
            HStack {
                Spacer()
                Text(headerTitle(for: destination))
                    .font(.system(size: 14, weight: .bold))
                    .kerning(-0.5)
                Spacer()
            }
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.5))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.black.opacity(0.15)),
                alignment: .bottom
            )
            
            switch destination {
            case .playlists: PlaylistsView()
            case .artists: ArtistsView()
            case .albums: AlbumsView()
            case .songs: SongsView()
            case .extras: ExtrasView()
            case .settings: SettingsView()
            case .nowPlaying: NowPlayingView()
            default: PlaceholderView(title: "Unknown")
            }
        }
    }
    
    private func headerTitle(for destination: MenuDestination) -> String {
        switch destination {
        case .playlists: return "PLAYLISTS"
        case .artists: return "ARTISTS"
        case .albums: return "ALBUMS"
        case .songs: return "SONGS"
        case .extras: return "EXTRAS"
        case .settings: return "SETTINGS"
        case .nowPlaying: return "NOW PLAYING"
        default: return "HAPBACK"
        }
    }
    
    private func handleRotation(_ direction: Int) {
        // Rotation only affects the home menu for now
        if navigationStack.isEmpty {
            let newIndex = selectedIndex + direction
            if newIndex >= 0 && newIndex < menuItems.count {
                selectedIndex = newIndex
            }
        }
    }
    
    private func handleCenterPress() {
        if navigationStack.isEmpty {
            let destination = menuItems[selectedIndex].destination
            navigationStack.append(destination)
        }
    }
    
    private func handleMenuPress() {
        if !navigationStack.isEmpty {
            navigationStack.removeLast()
        }
    }
}

struct ListItem: View {
    let item: MenuItem
    var isSelected: Bool = false
    
    var body: some View {
        HStack {
            Text(item.title)
                .font(.system(size: 18, weight: .bold))
                .kerning(-0.5)
                .foregroundColor(isSelected ? .white : .black)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isSelected ? .white : .black.opacity(0.6))
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