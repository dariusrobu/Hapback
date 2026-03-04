//
//  PlaceholderViews.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct ExtrasView: View {
    var body: some View {
        PlaceholderView(title: "Extras")
    }
}

struct PlaceholderView: View {
    let title: String
    
    // Theme Colors
    let chicagoFont = Font.system(size: 19, weight: .bold)
    let primaryColor = Color(red: 0, green: 0, blue: 0.5) // Navy Blue
    
    var body: some View {
        VStack {
            Spacer()
            Text(title.uppercased())
                .font(chicagoFont)
                .foregroundColor(.black)
            
            Text("CONTENT COMING SOON...")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.black.opacity(0.4))
                .padding(.top, 4)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}

