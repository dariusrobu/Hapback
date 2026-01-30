//
//  ContentView.swift
//  Hapback
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Text("Hapback")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("iPod Classic (6th Gen) Experience")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    ContentView()
}