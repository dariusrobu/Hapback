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
    
    // Theme Colors
    let chicagoFont = Font.system(size: 19, weight: .bold)
    let primaryColor = Color(red: 0, green: 0, blue: 0.5) // Navy Blue
    
    var body: some View {
        VStack(spacing: 0) {
            // List Content
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        if albums.isEmpty {
                            Text("NO ALBUMS FOUND")
                                .font(chicagoFont)
                                .foregroundColor(.black.opacity(0.4))
                                .padding(.top, 40)
                        } else {
                            ForEach(0..<albums.count, id: \.self) { index in
                                AlbumListItem(
                                    album: albums[index],
                                    isSelected: index == selectedIndex,
                                    chicagoFont: chicagoFont,
                                    primaryColor: primaryColor
                                )
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
        .background(Color.clear)
        .task {
            self.albums = await musicService.fetchAlbums(for: artist)
        }
    }
}

