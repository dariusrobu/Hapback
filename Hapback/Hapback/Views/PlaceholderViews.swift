//
//  PlaceholderViews.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

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
