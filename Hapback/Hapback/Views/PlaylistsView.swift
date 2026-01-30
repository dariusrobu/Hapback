//
//  PlaylistsView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct PlaylistsView: View {
    @Binding var selectedIndex: Int
    @State private var playlists: [Playlist] = []
    private let musicService = MusicLibraryService()
    
    var body: some View {
        VStack(spacing: 0) {
            // LCD Screen Content
            VStack(spacing: 0) {
                // Header Bar
                HStack {
                    Spacer()
                    Text("PLAYLISTS")
                        .font(.system(size: 14, weight: .bold))
                        .kerning(1.0)
                    Spacer()
                    Image(systemName: "battery.100")
                        .font(.system(size: 12))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.3))
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
                            if playlists.isEmpty {
                                Text("No Playlists Found")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.black.opacity(0.5))
                                    .padding(.top, 40)
                            } else {
                                ForEach(0..<playlists.count, id: \.self) { index in
                                    PlaylistListItem(playlist: playlists[index], isSelected: index == selectedIndex)
                                        .id(index)
                                }
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
            .background(Color(red: 216/255, green: 233/255, blue: 240/255)) // #d8e9f0
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            fetchPlaylists()
        }
    }
    
    private func fetchPlaylists() {
        self.playlists = musicService.fetchPlaylists()
    }
}

struct PlaylistListItem: View {
    let playlist: Playlist
    var isSelected: Bool = false
    
    var body: some View {
        HStack {
            Text(playlist.title)
                .font(.system(size: 18, weight: .bold))
                .kerning(-0.5)
                .foregroundColor(isSelected ? .white : .black)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isSelected ? .white : .black.opacity(0.6))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(isSelected ? Color(red: 0, green: 0, blue: 132/255) : Color.clear) // #000084
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.black.opacity(0.05)),
            alignment: .bottom
        )
    }
}

#Preview {
    PlaylistsView()
}
