//
//  PlaylistsView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct PlaylistsView: View {
    @Binding var selectedIndex: Int
    let playlists: [Playlist]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Spacer()
                Text("Playlists")
                    .font(.system(size: 20, weight: .bold)) // font-chicago approx
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
                        if playlists.isEmpty {
                            Text("No Playlists Found")
                                .font(.system(size: 19, weight: .bold))
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
                .onChange(of: selectedIndex) { oldIndex, newIndex in
                    withAnimation(.linear(duration: 0.1)) {
                        proxy.scrollTo(newIndex, anchor: .center)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PlaylistListItem: View {
    let playlist: Playlist
    var isSelected: Bool = false
    
    var body: some View {
        HStack {
            Text(playlist.title)
                .font(.system(size: 19, weight: .bold)) // font-chicago
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
    PlaylistsView(selectedIndex: .constant(0), playlists: [])
        .background(Color(red: 216/255, green: 233/255, blue: 240/255))
}
