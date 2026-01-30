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
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Spacer()
                Text("Albums")
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
    }
}

struct AlbumListItem: View {
    let album: Album
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Album Artwork Thumbnail
            if let image = album.artwork {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .cornerRadius(2)
                    .shadow(radius: 1)
            }
            else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)
                    .cornerRadius(2)
                    .overlay(
                        Image(systemName: "music.note")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(album.title)
                    .font(.system(size: 18, weight: .bold))
                    .kerning(-0.5)
                    .foregroundColor(isSelected ? .white : .black)
                    .lineLimit(1)
                
                Text(album.artist)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .black.opacity(0.6))
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(isSelected ? .white : .black)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isSelected ? Color(red: 0, green: 0, blue: 128/255) : Color.clear)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.black.opacity(0.05)),
            alignment: .bottom
        )
    }
}

#Preview {
    AlbumsView(selectedIndex: .constant(0), albums: [])
        .background(Color(red: 216/255, green: 233/255, blue: 240/255))
}
