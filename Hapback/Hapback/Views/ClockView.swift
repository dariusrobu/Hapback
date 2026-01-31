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
    
    var body: some View {
        VStack(spacing: 20) {
            // Header Bar
            HStack {
                Spacer()
                Text("Clock")
                    .font(.system(size: 20, weight: .bold))
                    .textCase(.uppercase)
                    .kerning(1.0)
                Spacer()
                Image(systemName: "battery.100")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.black.opacity(0.1)),
                alignment: .bottom
            )
            
            Spacer()
            
            VStack(spacing: 8) {
                Text(timeString(from: currentTime))
                    .font(.system(size: 64, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                
                Text(dateString(from: currentTime))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black.opacity(0.6))
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onReceive(timer) { input in
            currentTime = input
        }
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
    
    private func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}

#Preview {
    ClockView()
        .background(Color(red: 216/255, green: 233/255, blue: 240/255))
}
