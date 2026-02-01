//
//  NowPlayingView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI
import MediaPlayer

struct NowPlayingView: View {
    @ObservedObject var playbackManager = PlaybackManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Spacer()
                Text("NOW PLAYING")
                    .font(.system(size: 14, weight: .bold))
                    .kerning(-0.5)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.5))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.black.opacity(0.15)),
                alignment: .bottom
            )
            
            if let song = playbackManager.currentSong {
                VStack(spacing: 20) {
                    // Artwork and Metadata
                    HStack(alignment: .center, spacing: 16) {
                        // Album Artwork
                        if let image = song.artwork {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 128, height: 128)
                                .cornerRadius(2)
                                .shadow(radius: 2)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 128, height: 128)
                                .cornerRadius(2)
                                .overlay(
                                    Image(systemName: "music.note")
                                        .font(.system(size: 64))
                                        .foregroundColor(.white)
                                )
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(song.title)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .lineLimit(2)
                            
                            Text(song.artist)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.black.opacity(0.7))
                                .lineLimit(1)
                            
                            Text(song.albumTitle)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.black.opacity(0.5))
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Progress Bar Area
                    VStack(spacing: 8) {
                        HStack {
                            Text(formatTime(playbackManager.currentTime))
                            Spacer()
                            Text("-" + formatTime(playbackManager.duration - playbackManager.currentTime))
                        }
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.black.opacity(0.6))
                        .padding(.horizontal, 4)
                        
                        RetroSlider(progress: playbackManager.duration > 0 ? playbackManager.currentTime / playbackManager.duration : 0)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
            } else {
                VStack {
                    Spacer()
                    Text("No Song Selected")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black.opacity(0.5))
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

struct RetroSlider: View {
    var progress: Double // 0.0 to 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                Rectangle()
                    .fill(Color.white)
                    .overlay(
                        Rectangle()
                            .stroke(Color.black.opacity(0.2), lineWidth: 1)
                    )
                
                // Fill
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 139/255, green: 168/255, blue: 204/255), Color(red: 90/255, green: 125/255, blue: 163/255)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(progress))
                
                // Handle
                Circle()
                    .fill(Color(red: 58/255, green: 93/255, blue: 161/255))
                    .frame(width: 12, height: 12)
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.3), lineWidth: 1)
                    )
                    .offset(x: (geometry.size.width * CGFloat(progress)) - 6)
            }
        }
        .frame(height: 12)
    }
}

#Preview {
    NowPlayingView()
        .background(Color(red: 216/255, green: 233/255, blue: 240/255))
}
