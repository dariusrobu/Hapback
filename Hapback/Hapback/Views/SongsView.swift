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
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Button(action: {
                    isImporting = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                }
                .frame(width: 40, alignment: .leading)
                
                Spacer()
                Text("Songs")
                    .font(.system(size: 20, weight: .bold))
                    .textCase(.uppercase)
                    .kerning(1.0)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "battery.100")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 40, alignment: .trailing)
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
                        if songs.isEmpty {
                            VStack(spacing: 12) {
                                Text("No Songs Found")
                                    .font(.system(size: 19, weight: .bold))
                                    .foregroundColor(.black.opacity(0.5))
                                
                                Text("Tap the + icon to import music\nfrom your Files app.")
                                    .font(.system(size: 14))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black.opacity(0.4))
                            }
                            .padding(.top, 40)
                        } else {
                            ForEach(0..<songs.count, id: \.self) {
                                index in
                                SongListItem(song: songs[index], isSelected: index == selectedIndex)
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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(song.title)
                    .font(.system(size: 19, weight: .bold))
                    .kerning(-0.5)
                    .foregroundColor(isSelected ? .white : .black)
                    .lineLimit(1)
                
                Text(song.artist)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .black.opacity(0.6))
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
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
    SongsView(selectedIndex: .constant(0), songs: [])
        .background(Color(red: 216/255, green: 233/255, blue: 240/255))
}