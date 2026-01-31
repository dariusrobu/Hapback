//
//  StopwatchView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct StopwatchView: View {
    @ObservedObject var viewModel: StopwatchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Spacer()
                Text("Stopwatch")
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
                Text(viewModel.formattedTime)
                    .font(.system(size: 64, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                
                Text(viewModel.isRunning ? "RUNNING" : "STOPPED")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(viewModel.isRunning ? .green : .red)
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("Center: Start/Stop")
                Text("Menu: Reset (if stopped)")
            }
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.black.opacity(0.4))
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    StopwatchView(viewModel: StopwatchViewModel())
        .background(Color(red: 216/255, green: 233/255, blue: 240/255))
}
