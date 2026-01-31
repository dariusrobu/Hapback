//
//  ExtrasMenuView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct ExtrasMenuView: View {
    @Binding var selectedIndex: Int
    let items = MenuData.extrasMenuItems
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Spacer()
                Text("Extras")
                    .font(.system(size: 20, weight: .bold))
                    .textCase(.uppercase)
                    .kerning(1.0)
                Spacer()
                Image(systemName: "battery.100")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.clear)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.black.opacity(0.1)),
                alignment: .bottom
            )
            
            // List Content
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(0..<items.count, id: \.self) { index in
                            ListItem(item: items[index], isSelected: index == selectedIndex)
                                .id(index)
                        }
                    }
                }
                .onChange(of: selectedIndex) { oldIndex, newIndex in
                    withAnimation(.linear(duration: 0.1)) {
                        proxy.scrollTo(newIndex, anchor: .center)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct GamesMenuView: View {
    @Binding var selectedIndex: Int
    let items = MenuData.gamesMenuItems
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Spacer()
                Text("Games")
                    .font(.system(size: 20, weight: .bold))
                    .textCase(.uppercase)
                    .kerning(1.0)
                Spacer()
                Image(systemName: "battery.100")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.clear)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.black.opacity(0.1)),
                alignment: .bottom
            )
            
            // List Content
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(0..<items.count, id: \.self) { index in
                            ListItem(item: items[index], isSelected: index == selectedIndex)
                                .id(index)
                        }
                    }
                }
                .onChange(of: selectedIndex) { oldIndex, newIndex in
                    withAnimation(.linear(duration: 0.1)) {
                        proxy.scrollTo(newIndex, anchor: .center)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
