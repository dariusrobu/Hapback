//
//  PlaylistDetailView.swift
//  Hapback
//
//  Created by Conductor on 06.02.2026.
//

import SwiftUI

struct PlaylistDetailView: View {
    @Binding var selectedIndex: Int
    let playlist: Playlist
    
    // Theme Colors
    let chicagoFont = Font.system(size: 19, weight: .bold)
    let primaryColor = Color(red: 0, green: 0, blue: 0.5) // Navy Blue
    
    var body: some View {
        VStack(spacing: 0) {
            // List Content
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        if playlist.songs.isEmpty {
                            Text("NO SONGS FOUND")
                                .font(chicagoFont)
                                .foregroundColor(.black.opacity(0.4))
                                .padding(.top, 40)
                        } else {
                            ForEach(0..<playlist.songs.count, id: \.self) { index in
                                SongListItem(
                                    song: playlist.songs[index],
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
    }
}
