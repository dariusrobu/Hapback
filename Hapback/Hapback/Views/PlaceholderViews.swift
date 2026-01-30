//
//  PlaceholderViews.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct AlbumsView: View {
    var body: some View {
        PlaceholderView(title: "Albums")
    }
}

struct SongsView: View {
    var body: some View {
        PlaceholderView(title: "Songs")
    }
}

struct ExtrasView: View {
    var body: some View {
        PlaceholderView(title: "Extras")
    }
}

struct SettingsView: View {
    var body: some View {
        PlaceholderView(title: "Settings")
    }
}

struct NowPlayingView: View {
    var body: some View {
        VStack {
            Text("Now Playing")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            
            Image(systemName: "music.note")
                .font(.system(size: 100))
                .foregroundColor(.gray)
                .padding()
            
            Text("No song playing")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PlaceholderView: View {
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.black)
            Spacer()
            Text("Content coming soon...")
                .font(.headline)
                .foregroundColor(.gray)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
