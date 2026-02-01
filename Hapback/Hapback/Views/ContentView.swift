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
    @State private var songs: [Song] = []
    
    // Detail data sources
    @State private var artistAlbums: [Album] = []
    @State private var albumSongs: [Song] = []
    
    @StateObject private var stopwatchViewModel = StopwatchViewModel()
    @StateObject private var brickGameViewModel = BrickGameViewModel()
    
    private let musicService = MusicLibraryService()
    
    var currentDestination: MenuDestination {
        navigationStack.last ?? .unknown
    }
    
    var homeMenuItems: [MenuItem] {
        return MenuData.mainMenuItems
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
                                handlePlayPausePress()
                            },
                            onForwardPress: {
                                handleForwardPress()
                            },
                            onBackwardPress: {
                                handleBackwardPress()
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
            // Force a scan to "wake up" the Documents folder for the Files app
            let scanner = FileScannerService()
            _ = await scanner.scanDocumentsDirectory()
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
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "battery.100")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
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
            SongsView(selectedIndex: $selectedIndex, songs: songs, onImport: {
                Task {
                    self.songs = await musicService.fetchSongs()
                    updateCount()
                }
            })
            .task {
                self.songs = await musicService.fetchSongs()
                updateCount()
            }
        case .artistDetail(let artist):
            ArtistDetailView(selectedIndex: $selectedIndex, artist: artist)
                .task {
                    self.artistAlbums = await musicService.fetchAlbums(for: artist)
                    updateCount()
                }
        case .albumDetail(let album):
            AlbumDetailView(selectedIndex: $selectedIndex, album: album)
                .task {
                    self.albumSongs = await musicService.fetchSongs(for: album)
                    updateCount()
                }
        case .extras: 
            ExtrasMenuView(selectedIndex: $selectedIndex)
                .onAppear { updateCount() }
        case .games:
            GamesMenuView(selectedIndex: $selectedIndex)
                .onAppear { updateCount() }
        case .brick:
            BrickGameView(viewModel: brickGameViewModel)
                .onAppear { updateCount() }
        case .clock:
            ClockView()
                .onAppear { updateCount() }
        case .stopwatch:
            StopwatchView(viewModel: stopwatchViewModel)
                .onAppear { updateCount() }
        case .calendars:
            CalendarView()
                .onAppear { updateCount() }
        case .settings: 
            SettingsView()
                .onAppear { updateCount() }
        case .nowPlaying: 
            NowPlayingView()
                .onAppear { updateCount() }
        default: 
            PlaceholderView(title: "Coming Soon")
                .onAppear { updateCount() }
        }
    }
    
    private func handleRotation(_ direction: Int) {
        if currentDestination == .brick {
            brickGameViewModel.movePaddle(delta: CGFloat(direction) * 0.08)
            return
        }
        
        if currentDestination == .nowPlaying {
            // Adjust volume: each tick is ~2% volume change
            let delta = Double(direction) * 0.02
            PlaybackManager.shared.adjustVolume(by: delta)
        } else {
            // Standard list scrolling
            let newIndex = selectedIndex + direction
            if newIndex >= 0 && newIndex < currentItemsCount {
                selectedIndex = newIndex
            }
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
        } else {
            switch currentDestination {
            case .extras:
                let items = MenuData.extrasMenuItems
                if !items.isEmpty {
                    let destination = items[selectedIndex].destination
                    withAnimation {
                        navigationStack.append(destination)
                        selectedIndex = 0
                        updateCount()
                    }
                }
            case .games:
                let items = MenuData.gamesMenuItems
                if !items.isEmpty {
                    let destination = items[selectedIndex].destination
                    withAnimation {
                        navigationStack.append(destination)
                        selectedIndex = 0
                        updateCount()
                    }
                }
            case .artists:
                if !artists.isEmpty {
                    let artist = artists[selectedIndex]
                    withAnimation {
                        navigationStack.append(.artistDetail(artist))
                        selectedIndex = 0
                        updateCount()
                    }
                }
            case .albums:
                if !albums.isEmpty {
                    let album = albums[selectedIndex]
                    withAnimation {
                        navigationStack.append(.albumDetail(album) )
                        selectedIndex = 0
                        updateCount()
                    }
                }
            case .artistDetail:
                if !artistAlbums.isEmpty {
                    let album = artistAlbums[selectedIndex]
                    withAnimation {
                        navigationStack.append(.albumDetail(album))
                        selectedIndex = 0
                        updateCount()
                    }
                }
            case .albumDetail:
                if !albumSongs.isEmpty {
                    let song = albumSongs[selectedIndex]
                    PlaybackManager.shared.play(song, in: albumSongs)
                    withAnimation {
                        navigationStack.append(.nowPlaying)
                        selectedIndex = 0
                        updateCount()
                    }
                }
            case .songs:
                if !songs.isEmpty {
                    let song = songs[selectedIndex]
                    PlaybackManager.shared.play(song, in: songs)
                    withAnimation {
                        navigationStack.append(.nowPlaying)
                        selectedIndex = 0
                        updateCount()
                    }
                }
            case .nowPlaying:
                PlaybackManager.shared.togglePlayPause()
            case .stopwatch:
                stopwatchViewModel.toggle()
            case .brick:
                brickGameViewModel.togglePause()
            default:
                break
            }
        }
    }
    
    private func handleMenuPress() {
        if currentDestination == .stopwatch {
            if !stopwatchViewModel.isRunning && stopwatchViewModel.time > 0 {
                stopwatchViewModel.reset()
                return
            }
        }
        
        if currentDestination == .brick {
            if !brickGameViewModel.isPaused {
                brickGameViewModel.togglePause()
                return
            }
        }
        
        if !navigationStack.isEmpty {
            withAnimation {
                navigationStack.removeLast()
                selectedIndex = 0 
                updateCount()
            }
        }
    }
    
    private func handlePlayPausePress() {
        PlaybackManager.shared.togglePlayPause()
    }
    
    private func handleForwardPress() {
        if currentDestination == .brick {
            brickGameViewModel.movePaddle(delta: 0.1)
        } else {
            PlaybackManager.shared.skipForward()
        }
    }
    
    private func handleBackwardPress() {
        if currentDestination == .brick {
            brickGameViewModel.movePaddle(delta: -0.1)
        } else {
            PlaybackManager.shared.skipBackward()
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
            case .artistDetail:
                currentItemsCount = artistAlbums.count
            case .albumDetail:
                currentItemsCount = albumSongs.count
            case .extras:
                currentItemsCount = MenuData.extrasMenuItems.count
            case .games:
                currentItemsCount = MenuData.gamesMenuItems.count
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