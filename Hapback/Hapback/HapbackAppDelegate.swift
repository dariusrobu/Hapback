//
//  HapbackAppDelegate.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import UIKit
import AVFoundation

class HapbackAppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        setupAudioSession()
        return true
    }
    
    private func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            // Standard playback category that ignores the silent switch
            try session.setCategory(.playback, mode: .default, options: [.allowBluetoothA2DP, .allowAirPlay])
            try session.setActive(true)
            print("DEBUG: AppDelegate successfully activated audio session")
        } catch {
            print("ERROR: AppDelegate failed to set up audio session: \(error)")
        }
    }
}
