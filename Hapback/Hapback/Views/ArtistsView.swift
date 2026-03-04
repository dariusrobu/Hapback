//
//  ArtistsView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct ArtistsView: View {
    @Binding var selectedIndex: Int
    let artists: [Artist]
    
    // Theme Colors
    let chicagoFont = Font.system(size: 19, weight: .bold)
    let primaryColor = Color(red: 0, green: 0, blue: 0.5) // Navy Blue
    
    var body: some View {
        VStack(spacing: 0) {
            // List Content
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        if artists.isEmpty {
                            Text("NO ARTISTS FOUND")
                                .font(chicagoFont)
                                .foregroundColor(.black.opacity(0.4))
                                .padding(.top, 40)
                        } else {
                            ForEach(0..<artists.count, id: \.self) { index in
                                ArtistListItem(
                                    artist: artists[index],
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

struct ArtistListItem: View {
    let artist: Artist
    var isSelected: Bool = false
    let chicagoFont: Font
    let primaryColor: Color
    
    var body: some View {
        HStack {
            Text(artist.name)
                .font(chicagoFont)
                .lineLimit(1)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .bold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(isSelected ? primaryColor : Color.clear)
        .foregroundColor(isSelected ? .white : .black)
        .border(width: 1, edges: [.bottom], color: .black.opacity(0.05))
    }
}

#Preview {
    ArtistsView(selectedIndex: .constant(0), artists: [])
}

