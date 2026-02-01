//
//  ArtistDetailView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct ArtistDetailView: View {
    @Binding var selectedIndex: Int
    let artist: Artist
    @State private var albums: [Album] = []
    private let musicService = MusicLibraryService()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Spacer()
                Text(artist.name)
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
                        if albums.isEmpty {
                            Text("No Albums Found")
                                .font(.system(size: 19, weight: .bold))
                                .foregroundColor(.black.opacity(0.5))
                                .padding(.top, 40)
                        } else {
                            ForEach(0..<albums.count, id: \.self) { index in
                                AlbumListItem(album: albums[index], isSelected: index == selectedIndex)
                                    .id(index)
                            }
                        }
                    }
                }
                .onChange(of: selectedIndex) { oldIndex, newIndex in
                    withAnimation(.linear(duration: 0.1)) {
                        proxy.scrollTo(newIndex, anchor: .center)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            self.albums = await musicService.fetchAlbums(for: artist)
        }
    }
}
