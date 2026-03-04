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
    
    // Theme Colors (LCD Style)
    let lcdTopColor = Color(red: 240/255, green: 248/255, blue: 1.0) // aliceblue
    let lcdBottomColor = Color(red: 230/255, green: 240/255, blue: 1.0)
    let primaryColor = Color(red: 0/255, green: 0/255, blue: 128/255) // Navy Blue
    let chicagoFont = Font.system(size: 18, weight: .bold)
    let chicagoFontSmall = Font.system(size: 14, weight: .bold)
    
    var body: some View {
        ZStack {
            // Screen background gradient
            LinearGradient(gradient: Gradient(colors: [lcdTopColor, lcdBottomColor]), startPoint: .top, endPoint: .bottom)
            
            VStack(spacing: 0) {
                if let song = playbackManager.currentSong {
                    VStack(spacing: 12) {
                        // Artwork
                        if let image = song.artwork {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 140, height: 140)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                                .padding(.top, 16)
                        } else {
                            Rectangle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 140, height: 140)
                                .clipShape(RoundedRectangle(cornerRadius: 2))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                                .overlay(
                                    Image(systemName: "music.note")
                                        .font(.system(size: 60))
                                        .foregroundColor(primaryColor.opacity(0.3))
                                )
                                .padding(.top, 16)
                        }
                        
                        // Metadata
                        VStack(spacing: 4) {
                            Text(song.title)
                                .font(chicagoFont)
                                .foregroundColor(.black)
                                .lineLimit(1)
                            
                            Text(song.artist)
                                .font(chicagoFontSmall)
                                .foregroundColor(.black.opacity(0.7))
                                .lineLimit(1)
                            
                            Text(song.albumTitle)
                                .font(chicagoFontSmall)
                                .foregroundColor(.black.opacity(0.6))
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                        
                        // Progress Bar Area
                        VStack(spacing: 6) {
                            ClassicSlider(
                                progress: playbackManager.duration > 0 ? playbackManager.currentTime / playbackManager.duration : 0,
                                primaryColor: primaryColor
                            )
                            
                            HStack {
                                Text(formatTime(playbackManager.currentTime))
                                Spacer()
                                Text(formatTime(playbackManager.duration))
                            }
                            .font(chicagoFontSmall)
                            .foregroundColor(.black.opacity(0.6))
                            .padding(.horizontal, 4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 24)
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("NO SONG PLAYING")
                            .font(chicagoFont)
                            .foregroundColor(primaryColor.opacity(0.4))
                        Spacer()
                    }
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

struct ClassicSlider: View {
    var progress: Double // 0.0 to 1.0
    var primaryColor: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.white)
                    .frame(height: 14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 1)
                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
                    )
                
                // Fill
                LinearGradient(gradient: Gradient(colors: [primaryColor.opacity(0.8), primaryColor]), startPoint: .top, endPoint: .bottom)
                    .frame(width: geometry.size.width * CGFloat(progress), height: 14)
                    .clipShape(RoundedRectangle(cornerRadius: 1))
            }
        }
        .frame(height: 14)
    }
}

#Preview {
    NowPlayingView()
}

