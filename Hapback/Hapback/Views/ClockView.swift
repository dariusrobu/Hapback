//
//  ClockView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI
import Combine

struct ClockView: View {
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Theme Colors
    let chicagoFont = Font.system(size: 19, weight: .bold)
    let chicagoFontLarge = Font.system(size: 64, weight: .bold)
    let primaryColor = Color(red: 0, green: 0, blue: 0.5) // Navy Blue
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 8) {
                Text(timeString(from: currentTime))
                    .font(chicagoFontLarge)
                    .foregroundColor(.black)
                
                Text(dateString(from: currentTime).uppercased())
                    .font(chicagoFont)
                    .foregroundColor(.black.opacity(0.6))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .onReceive(timer) { input in
            currentTime = input
        }
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    ClockView()
}

