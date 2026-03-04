//
//  StopwatchView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct StopwatchView: View {
    @ObservedObject var viewModel: StopwatchViewModel
    
    // Theme Colors
    let chicagoFont = Font.system(size: 19, weight: .bold)
    let chicagoFontSmall = Font.system(size: 14, weight: .bold)
    let chicagoFontLarge = Font.system(size: 54, weight: .bold)
    let primaryColor = Color(red: 0, green: 0, blue: 0.5) // Navy Blue
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: 12) {
                Text(viewModel.formattedTime)
                    .font(chicagoFontLarge)
                    .foregroundColor(.black)
                    .tracking(-1.0)
                
                Text(viewModel.isRunning ? "RUNNING" : "STOPPED")
                    .font(chicagoFont)
                    .foregroundColor(viewModel.isRunning ? primaryColor : .black.opacity(0.4))
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Text("CENTER TO START/STOP")
                Text("MENU TO RESET")
            }
            .font(chicagoFontSmall)
            .foregroundColor(.black.opacity(0.5))
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}

#Preview {
    StopwatchView(viewModel: StopwatchViewModel())
}

