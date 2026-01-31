//
//  HapbackApp.swift
//  Hapback
//
//  Created by Robu Darius on 30.01.2026.
//

import SwiftUI
import SwiftData
import AVFoundation

@main
struct HapbackApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
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
                .onAppear {
                    // Pre-initialize PlaybackManager to setup audio session and remote commands
                    _ = PlaybackManager.shared
                }
        }
        .modelContainer(sharedModelContainer)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                print("DEBUG: App entered background, ensuring session is active")
                try? AVAudioSession.sharedInstance().setActive(true)
            }
        }
    }
}
