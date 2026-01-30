//
//  HapbackApp.swift
//  Hapback
//
//  Created by Robu Darius on 30.01.2026.
//

import SwiftUI
import SwiftData

@main
struct HapbackApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            // Add your models here
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
