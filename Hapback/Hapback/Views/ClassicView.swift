
import SwiftUI
import SwiftData

struct ClassicView: View {
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
    @State private var playlistSongs: [Song] = []
    
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
        ZStack {
            // This is the main background of the "device"
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 1.0, blue: 1.0),
                    Color(red: 247/255, green: 247/255, blue: 247/255),
                    Color(red: 238/255, green: 238/255, blue: 238/255)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top part: LCD Screen
                LCDView(
                    selectedIndex: $selectedIndex,
                    navigationStack: $navigationStack,
                    playlists: $playlists,
                    artists: $artists,
                    albums: $albums,
                    songs: $songs,
                    artistAlbums: $artistAlbums,
                    albumSongs: $albumSongs,
                    playlistSongs: $playlistSongs,
                    stopwatchViewModel: stopwatchViewModel,
                    brickGameViewModel: brickGameViewModel
                )
                .frame(height: UIScreen.main.bounds.height / 2)
                
                // Bottom part: Click Wheel
                ClassicClickWheelView(
                    onMenuPress: handleMenuPress,
                    onPlayPausePress: handlePlayPausePress,
                    onPrevPress: handleBackwardPress,
                    onNextPress: handleForwardPress,
                    onTick: handleRotation,
                    onCenterPress: handleCenterPress
                )
                .frame(height: UIScreen.main.bounds.height / 2)
            }
        }
        .preferredColorScheme(.light)
        .task {
            _ = await musicService.requestAuthorization()
            let scanner = FileScannerService()
            _ = await scanner.scanDocumentsDirectory()
            updateCount()
        }
    }
    
    // MARK: - Logic Handlers (Copied from ContentView)
    
    private func handleRotation(_ direction: Int) {
        if currentDestination == .brick {
            brickGameViewModel.movePaddle(delta: CGFloat(direction) * 0.08)
            return
        }
        
        if currentDestination == .nowPlaying {
            let delta = Double(direction) * 0.02
            PlaybackManager.shared.adjustVolume(by: delta)
        } else {
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
            case .playlists:
                if !playlists.isEmpty {
                    let playlist = playlists[selectedIndex]
                    withAnimation {
                        navigationStack.append(.playlistDetail(playlist))
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
            case .playlistDetail:
                if !playlistSongs.isEmpty {
                    let song = playlistSongs[selectedIndex]
                    PlaybackManager.shared.play(song, in: playlistSongs)
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
        DispatchQueue.main.async {
            if navigationStack.isEmpty {
                self.currentItemsCount = self.homeMenuItems.count
            } else {
                switch self.currentDestination {
                case .playlists:
                    self.currentItemsCount = self.playlists.count
                case .artists:
                    self.currentItemsCount = self.artists.count
                case .albums:
                    self.currentItemsCount = self.albums.count
                case .songs:
                    self.currentItemsCount = self.songs.count
                case .artistDetail:
                    self.currentItemsCount = self.artistAlbums.count
                case .albumDetail:
                    self.currentItemsCount = self.albumSongs.count
                case .playlistDetail(let playlist):
                    self.currentItemsCount = playlist.songs.count
                case .extras:
                    self.currentItemsCount = MenuData.extrasMenuItems.count
                case .games:
                    self.currentItemsCount = MenuData.gamesMenuItems.count
                default:
                    self.currentItemsCount = 0
                }
            }
        }
    }
}

#Preview {
    ClassicView()
}
