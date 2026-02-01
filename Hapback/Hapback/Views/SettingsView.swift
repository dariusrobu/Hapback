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
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Spacer()
                Text("Settings")
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
            
            // Settings List
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    SettingsItem(label: "About", value: "Hapback v1.0")
                    SettingsItem(label: "Songs", value: "\(songCount)")
                    SettingsItem(label: "Capacity", value: storageUsed)
                    SettingsItem(label: "Legal", value: "")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    
    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 19, weight: .bold))
                .foregroundColor(.black)
            Spacer()
            Text(value)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black.opacity(0.6))
            
            if value.isEmpty {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.black.opacity(0.3))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.clear)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.black.opacity(0.05)),
            alignment: .bottom
        )
    }
}
