//
//  SettingsView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct SettingsView: View {
    @State private var songCount: Int = 0
    @State private var storageUsed: String = "0 KB"
    private let musicService = MusicLibraryService()
    private let scanner = FileScannerService()
    
    // Theme Colors
    let chicagoFont = Font.system(size: 19, weight: .bold)
    let chicagoFontSmall = Font.system(size: 15, weight: .bold)
    let primaryColor = Color(red: 0, green: 0, blue: 0.5) // Navy Blue
    
    var body: some View {
        VStack(spacing: 0) {
            // Settings List
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    SettingsItem(label: "About", value: "Hapback v1.0", chicagoFont: chicagoFont, chicagoFontSmall: chicagoFontSmall)
                    SettingsItem(label: "Songs", value: "\(songCount)", chicagoFont: chicagoFont, chicagoFontSmall: chicagoFontSmall)
                    SettingsItem(label: "Capacity", value: storageUsed, chicagoFont: chicagoFont, chicagoFontSmall: chicagoFontSmall)
                    SettingsItem(label: "Legal", value: "", chicagoFont: chicagoFont, chicagoFontSmall: chicagoFontSmall)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .task {
            let songs = await musicService.fetchSongs()
            self.songCount = songs.count
            
            let bytes = scanner.calculateTotalStorageUsed()
            self.storageUsed = formatBytes(bytes)
        }
    }
    
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}

struct SettingsItem: View {
    let label: String
    let value: String
    let chicagoFont: Font
    let chicagoFontSmall: Font
    
    var body: some View {
        HStack {
            Text(label)
                .font(chicagoFont)
                .foregroundColor(.black)
            
            Spacer()
            
            if !value.isEmpty {
                Text(value)
                    .font(chicagoFontSmall)
                    .foregroundColor(.black.opacity(0.6))
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.black.opacity(0.3))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.clear)
        .border(width: 1, edges: [.bottom], color: .black.opacity(0.05))
    }
}

