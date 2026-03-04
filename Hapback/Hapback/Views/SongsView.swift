//
//  SongsView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI
import MediaPlayer
import UniformTypeIdentifiers

struct SongsView: View {
    @Binding var selectedIndex: Int
    let songs: [Song]
    var onImport: (() -> Void)?
    
    @State private var isImporting = false
    private let scanner = FileScannerService()
    
    // Theme Colors
    let chicagoFont = Font.system(size: 19, weight: .bold)
    let chicagoFontSmall = Font.system(size: 15, weight: .bold)
    let primaryColor = Color(red: 0, green: 0, blue: 0.5) // Navy Blue
    
    var body: some View {
        VStack(spacing: 0) {
            // List Content
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        if songs.isEmpty {
                            VStack(spacing: 16) {
                                Text("NO SONGS FOUND")
                                    .font(chicagoFont)
                                    .foregroundColor(.black.opacity(0.4))
                                
                                Button(action: {
                                    isImporting = true
                                }) {
                                    Text("IMPORT MUSIC")
                                        .font(chicagoFontSmall)
                                        .foregroundColor(primaryColor)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(primaryColor, lineWidth: 1)
                                        )
                                }
                            }
                            .padding(.top, 60)
                        } else {
                            ForEach(0..<songs.count, id: \.self) {
                                index in
                                SongListItem(
                                    song: songs[index],
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
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.audio, .mp3, .mpeg4Audio],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                Task {
                    for url in urls {
                        await scanner.importFile(from: url)
                    }
                    onImport?()
                }
            case .failure(let error):
                print("Import failed: \(error.localizedDescription)")
            }
        }
    }
}

struct SongListItem: View {
    let song: Song
    var isSelected: Bool = false
    let chicagoFont: Font
    let primaryColor: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(song.title)
                    .font(chicagoFont)
                    .lineLimit(1)
                
                Text(song.artist)
                    .font(.system(size: 14, weight: .bold))
                    .opacity(isSelected ? 0.9 : 0.6)
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(isSelected ? primaryColor : Color.clear)
        .foregroundColor(isSelected ? .white : .black)
        .border(width: 1, edges: [.bottom], color: .black.opacity(0.05))
    }
}

#Preview {
    SongsView(selectedIndex: .constant(0), songs: [])
}