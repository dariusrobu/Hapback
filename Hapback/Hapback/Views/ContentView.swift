//
//  ContentView.swift
//  Hapback
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedIndex = 0
    @State private var navigationStack: [MenuDestination] = []
    @State private var currentItemsCount = 0
    
    // Data sources
    @State private var playlists: [Playlist] = []
    @State private var artists: [Artist] = []
    @State private var albums: [Album] = []
    private let musicService = MusicLibraryService()
    
    var currentDestination: MenuDestination {
        navigationStack.last ?? .unknown
    }
    
    var homeMenuItems: [MenuItem] {
        let allItems = MenuData.mainMenuItems
        // Mock condition for Now Playing visibility
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
                VStack(spacing: 0) {
                    // Display Area (Top 50%)
                    VStack {
                        // LCD Screen Container
                        VStack(spacing: 0) {
                            if navigationStack.isEmpty {
                                homeMenuView
                            } else {
                                destinationView(for: currentDestination)
                            }
                        }
                        .background(lcdBackgroundColor)
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(lcdBorderColor, lineWidth: 3)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black.opacity(0.15), lineWidth: 4)
                                .blur(radius: 4)
                                .offset(x: 0, y: 2)
                                .mask(RoundedRectangle(cornerRadius: 4))
                        )
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding(.top, 40)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)
                    }
                    .frame(height: outerGeometry.size.height * 0.5)
                    .background(Color(red: 248/255, green: 248/255, blue: 248/255)) // ipod-white
                    
                    // Wheel Area (Bottom 50%)
                    ZStack {
                        // Polycarbonate Gradient for the bottom half
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white, Color(white: 0.94), Color(white: 0.90)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        ClickWheelView(
                            onTick: { direction in
                                handleRotation(direction)
                            },
                            onCenterPress: {
                                handleCenterPress()
                            },
                            onMenuPress: {
                                handleMenuPress()
                            },
                            onPlayPausePress: {
                                PlaybackManager.shared.togglePlayPause()
                            },
                            onForwardPress: {
                                PlaybackManager.shared.skipForward()
                            },
                            onBackwardPress: {
                                PlaybackManager.shared.skipBackward()
                            }
                        )
                        .frame(width: 280, height: 300)
                    }
                    .frame(height: outerGeometry.size.height * 0.5)
                }
            }
        }
        .task {
            // Request permissions at startup to avoid crashes later
            _ = await musicService.requestAuthorization()
            updateCount()
        }
    }
    
    private var lcdBackgroundColor: Color {
        if navigationStack.isEmpty {
            return Color(red: 240/255, green: 248/255, blue: 1.0)
        } else {
            return Color(red: 216/255, green: 233/255, blue: 240/255) // #d8e9f0
        }
    }
    
    private var lcdBorderColor: Color {
        return Color(red: 132/255, green: 132/255, blue: 132/255) // #848484
    }
    
    private var homeMenuView: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Spacer()
                Text("Hapback")
                    .font(.system(size: 20, weight: .bold))
                    .textCase(.uppercase)
                    .kerning(1.0)
                Spacer()
                Image(systemName: "battery.100")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.clear)
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
                        ForEach(0..<homeMenuItems.count, id: \.self) { index in
                            ListItem(item: homeMenuItems[index], isSelected: index == selectedIndex)
                                .id(index)
                        }
                    }
                }
                .onChange(of: selectedIndex) { oldIndex, newIndex in
                    if navigationStack.isEmpty {
                        withAnimation(.linear(duration: 0.1)) {
                            proxy.scrollTo(newIndex, anchor: .center)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for destination: MenuDestination) -> some View {
        switch destination {
        case .playlists: 
            PlaylistsView(selectedIndex: $selectedIndex, playlists: playlists)
                .task {
                    self.playlists = await musicService.fetchPlaylists()
                    updateCount()
                }
        case .artists: 
            ArtistsView(selectedIndex: $selectedIndex, artists: artists)
                .task {
                    self.artists = await musicService.fetchArtists()
                    updateCount()
                }
        case .albums: 
            AlbumsView(selectedIndex: $selectedIndex, albums: albums)
                .task {
                    self.albums = await musicService.fetchAlbums()
                    updateCount()
                }
        case .songs: 
            SongsView(selectedIndex: $selectedIndex, songs: songs)
                .task {
                    self.songs = await musicService.fetchSongs()
                    updateCount()
                }
        case .extras: 
            PlaceholderView(title: "Extras")
                .onAppear { updateCount() }
        case .settings: 
            PlaceholderView(title: "Settings")
                .onAppear { updateCount() }
        case .nowPlaying: 
            NowPlayingView()
                .onAppear { updateCount() }
        default: 
            PlaceholderView(title: "Unknown")
                .onAppear { updateCount() }
        }
    }
    
    private func handleRotation(_ direction: Int) {
        if navigationStack.isEmpty || currentDestination != .nowPlaying {
            let newIndex = selectedIndex + direction
            if newIndex >= 0 && newIndex < currentItemsCount {
                selectedIndex = newIndex
            }
        } else if currentDestination == .nowPlaying {
            // Adjust volume: each tick is ~2% volume change
            let delta = Double(direction) * 0.02
            PlaybackManager.shared.adjustVolume(by: delta)
        }
    }
    
    private func handleCenterPress() {
        if navigationStack.isEmpty {
            let destination = homeMenuItems[selectedIndex].destination
            withAnimation {
                navigationStack.append(destination)
                selectedIndex = 0
                updateCount()
            }
        } else if currentDestination == .songs && !songs.isEmpty {
            let song = songs[selectedIndex]
            PlaybackManager.shared.play(song)
            withAnimation {
                navigationStack.append(.nowPlaying)
                selectedIndex = 0
                updateCount()
            }
        } else if currentDestination == .nowPlaying {
            PlaybackManager.shared.togglePlayPause()
        }
    }
    
    private func handleMenuPress() {
        if !navigationStack.isEmpty {
            withAnimation {
                navigationStack.removeLast()
                selectedIndex = 0 
                updateCount()
            }
        }
    }
    
    private func updateCount() {
        if navigationStack.isEmpty {
            currentItemsCount = homeMenuItems.count
        } else {
            switch currentDestination {
            case .playlists:
                currentItemsCount = playlists.count
            case .artists:
                currentItemsCount = artists.count
            case .albums:
                currentItemsCount = albums.count
            case .songs:
                currentItemsCount = songs.count
            default:
                currentItemsCount = 0
            }
        }
    }
}

struct ListItem: View {
    let item: MenuItem
    var isSelected: Bool = false
    
    var body: some View {
        HStack {
            Text(item.title)
                .font(.system(size: 19, weight: .bold))
                .kerning(-0.5)
                .foregroundColor(isSelected ? .white : .black)
                .lineLimit(1)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(isSelected ? .white : .black)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isSelected ? Color(red: 0, green: 0, blue: 128/255) : Color.clear) // #000084
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
