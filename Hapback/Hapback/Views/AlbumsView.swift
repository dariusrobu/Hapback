//
//  AlbumsView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI
import MediaPlayer

struct AlbumsView: View {
    @Binding var selectedIndex: Int
    let albums: [Album]
    
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
    }
}

struct AlbumListItem: View {
    let album: Album
    var isSelected: Bool = false
    let chicagoFont: Font
    let primaryColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            // Album Artwork Thumbnail
            if let image = album.artwork {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 1))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            }
            else {
                Rectangle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 44, height: 44)
                    .clipShape(RoundedRectangle(cornerRadius: 1))
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 24))
                            .foregroundColor(primaryColor.opacity(0.3))
                    )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(album.title)
                    .font(chicagoFont)
                    .lineLimit(1)
                
                Text(album.artist)
                    .font(.system(size: 14, weight: .bold))
                    .opacity(isSelected ? 0.9 : 0.6)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(isSelected ? primaryColor : Color.clear)
        .foregroundColor(isSelected ? .white : .black)
        .border(width: 1, edges: [.bottom], color: .black.opacity(0.05))
    }
}

#Preview {
    AlbumsView(selectedIndex: .constant(0), albums: [])
}

