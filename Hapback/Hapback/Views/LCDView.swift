
import SwiftUI

struct LCDView: View {
    // Bindings to data and state from ClassicView
    @Binding var selectedIndex: Int
    @Binding var navigationStack: [MenuDestination]
    
    // Data sources
    @Binding var playlists: [Playlist]
    @Binding var artists: [Artist]
    @Binding var albums: [Album]
    @Binding var songs: [Song]
    
    // Detail data sources
    @Binding var artistAlbums: [Album]
    @Binding var albumSongs: [Song]
    @Binding var playlistSongs: [Song]
    
    @ObservedObject var stopwatchViewModel: StopwatchViewModel
    @ObservedObject var brickGameViewModel: BrickGameViewModel
    
    private let musicService = MusicLibraryService()

    // --- Theme ---
    let primaryColor = Color(red: 0, green: 0, blue: 0.5) // Navy Blue
    let lcdTopColor = Color(red: 240/255, green: 248/255, blue: 1.0) // aliceblue
    let lcdBottomColor = Color(red: 230/255, green: 240/255, blue: 1.0)
    let chicagoFont = Font.system(size: 19, weight: .bold)
    let chicagoFontSmall = Font.system(size: 15, weight: .bold)
    
    var homeMenuItems: [MenuItem] {
        return MenuData.mainMenuItems
    }
    
    var currentDestination: MenuDestination {
        navigationStack.last ?? .unknown
    }

    var body: some View {
        VStack(spacing: 0) {
            // The bezel around the screen
            Spacer().frame(height: UIScreen.main.bounds.height * 0.05) // Top space
            
            // The Screen
            ZStack {
                // Screen background gradient
                LinearGradient(gradient: Gradient(colors: [lcdTopColor, lcdBottomColor]), startPoint: .top, endPoint: .bottom)
                
                VStack(spacing: 0) {
                    // Header
                    HeaderView(title: title(for: currentDestination))
                    
                    // Content
                    ZStack {
                        if navigationStack.isEmpty {
                            ClassicList(items: homeMenuItems, selectedIndex: $selectedIndex)
                        } else {
                            destinationView(for: currentDestination)
                        }
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.black.opacity(0.15), lineWidth: 1.5)
            )
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal, 16)
            
            Spacer().frame(height: 10) // Pushes the screen up
        }
    }
    
    private func title(for destination: MenuDestination) -> String {
        if navigationStack.isEmpty { return "Hapback" }
        
        switch destination {
        case .playlists: return "Playlists"
        case .artists: return "Artists"
        case .albums: return "Albums"
        case .songs: return "Songs"
        case .extras: return "Extras"
        case .settings: return "Settings"
        case .nowPlaying: return "Now Playing"
        case .artistDetail(let artist): return artist.name
        case .albumDetail(let album): return album.title
        case .playlistDetail(let playlist): return playlist.title
        case .games: return "Games"
        case .brick: return "Brick"
        case .clock: return "Clock"
        case .stopwatch: return "Stopwatch"
        case .calendars: return "Calendar"
        default: return "Hapback"
        }
    }

    @ViewBuilder
    private func destinationView(for destination: MenuDestination) -> some View {
        Group {
            switch destination {
            case .playlists:
                ClassicList(items: playlists.map { MenuItem(title: $0.title, icon: "music.note.list", destination: .playlistDetail($0)) }, selectedIndex: $selectedIndex)
                    .task { self.playlists = await musicService.fetchPlaylists() }
            case .artists:
                ClassicList(items: artists.map { MenuItem(title: $0.name, icon: "music.mic", destination: .artistDetail($0)) }, selectedIndex: $selectedIndex)
                    .task { self.artists = await musicService.fetchArtists() }
            case .albums:
                ClassicList(items: albums.map { MenuItem(title: $0.title, icon: "square.stack", destination: .albumDetail($0)) }, selectedIndex: $selectedIndex)
                    .task { self.albums = await musicService.fetchAlbums() }
            case .songs:
                ClassicList(items: songs.map { MenuItem(title: $0.title, icon: "music.note", destination: .nowPlaying) }, selectedIndex: $selectedIndex)
                    .task { self.songs = await musicService.fetchSongs() }
            case .artistDetail:
                 ClassicList(items: artistAlbums.map { MenuItem(title: $0.title, icon: "square.stack", destination: .albumDetail($0)) }, selectedIndex: $selectedIndex)
                     .task {
                         if case let .artistDetail(artist) = destination {
                             self.artistAlbums = await musicService.fetchAlbums(for: artist)
                         }
                     }
            case .albumDetail:
                ClassicList(items: albumSongs.map { MenuItem(title: $0.title, icon: "music.note", destination: .nowPlaying) }, selectedIndex: $selectedIndex)
                    .task {
                        if case let .albumDetail(album) = destination {
                            self.albumSongs = await musicService.fetchSongs(for: album)
                        }
                    }
            case .playlistDetail:
                 ClassicList(items: playlistSongs.map { MenuItem(title: $0.title, icon: "music.note", destination: .nowPlaying) }, selectedIndex: $selectedIndex)
                    .task {
                        if case let .playlistDetail(playlist) = destination {
                            self.playlistSongs = playlist.songs
                        }
                    }
            case .extras:
                ClassicList(items: MenuData.extrasMenuItems, selectedIndex: $selectedIndex)
            case .games:
                ClassicList(items: MenuData.gamesMenuItems, selectedIndex: $selectedIndex)
            case .brick:
                BrickGameView(viewModel: brickGameViewModel)
            case .clock:
                ClockView()
            case .stopwatch:
                StopwatchView(viewModel: stopwatchViewModel)
            case .calendars:
                CalendarView()
            case .settings:
                SettingsView()
            case .nowPlaying:
                NowPlayingView()
            default:
                PlaceholderView(title: "Coming Soon")
            }
        }
    }
}


// MARK: - Subviews for LCDView

private struct HeaderView: View {
    let title: String
    let chicagoFont = Font.system(size: 16, weight: .bold)

    var body: some View {
        HStack {
            Image(systemName: "play.fill")
                .font(.system(size: 10))
                .foregroundColor(.black.opacity(0.8))
                .frame(width: 30, alignment: .leading)
            
            Spacer()
            
            Text(title.uppercased())
                .font(chicagoFont)
                .tracking(0.5)
                .lineLimit(1)
            
            Spacer()
            
            Image(systemName: "battery.75")
                .font(.system(size: 16))
                .foregroundColor(.black.opacity(0.8))
                .frame(width: 30, alignment: .trailing)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.35))
        .border(width: 1, edges: [.bottom], color: .black.opacity(0.12))
    }
}

private struct ClassicList: View {
    let items: [MenuItem]
    @Binding var selectedIndex: Int
    
    let primaryColor = Color(red: 0/255, green: 0/255, blue: 128/255) // Navy Blue #000080
    let chicagoFont = Font.system(size: 18, weight: .bold)

    var body: some View {
        HStack(spacing: 0) {
            ScrollViewReader { proxy in
                List(items.indices, id: \.self) { index in
                    HStack {
                        Text(items[index].title)
                            .font(chicagoFont)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .bold))
                            .opacity(selectedIndex == index ? 1 : 0.6)
                    }
                    .listRowSeparator(.visible, edges: .bottom)
                    .listRowSeparatorTint(Color.black.opacity(0.05))
                    .listRowInsets(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
                    .listRowBackground(selectedIndex == index ? primaryColor : Color.clear)
                    .foregroundColor(selectedIndex == index ? .white : .black)
                    .id(index)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .onChange(of: selectedIndex) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        proxy.scrollTo(selectedIndex, anchor: .center)
                    }
                }
            }
            
            // Custom Scroll Track like iPod
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color.black.opacity(0.1))
                    .frame(width: 18)
                    .border(width: 1, edges: [.leading], color: .black.opacity(0.15))
                
                if items.count > 0 {
                    let thumbHeight = max(20.0, 180.0 / CGFloat(items.count))
                    let thumbOffset = CGFloat(selectedIndex) * (180.0 - thumbHeight) / max(1.0, CGFloat(items.count - 1))
                    
                    Rectangle()
                        .fill(Color(white: 0.2))
                        .frame(width: 14, height: thumbHeight)
                        .border(Color.black, width: 1)
                        .offset(y: thumbOffset)
                        .padding(.top, 2)
                }
            }
        }
    }
}

// Edge-specific border modifier
extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }
            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }
            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }
            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}
