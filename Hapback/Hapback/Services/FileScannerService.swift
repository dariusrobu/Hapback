//
//  FileScannerService.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import Foundation
import AVFoundation
import UIKit

@MainActor
class FileScannerService {
    
    func scanDocumentsDirectory() async -> [Song] {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        
        // Ensure the folder is "active" so it shows up in the Files app
        let readmeURL = documentsURL.appendingPathComponent("Put Your Music Here.txt")
        if !fileManager.fileExists(atPath: readmeURL.path) {
            try? "Copy your MP3, M4A, or WAV files into this folder to play them in Hapback.".write(to: readmeURL, atomically: true, encoding: .utf8)
        }
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            let audioExtensions = ["mp3", "m4a", "wav", "alac", "aif", "aiff"]
            
            var localSongs: [Song] = []
            
            for url in fileURLs {
                if audioExtensions.contains(url.pathExtension.lowercased()) {
                    if let song = await extractMetadata(from: url) {
                        localSongs.append(song)
                    }
                }
            }
            
            return localSongs
        } catch {
            print("Error scanning documents directory: \(error.localizedDescription)")
            return []
        }
    }
    
    func importFile(from url: URL) async {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        // Start accessing the security-scoped resource
        guard url.startAccessingSecurityScopedResource() else {
            print("Failed to access security-scoped resource")
            return
        }
        
        defer { url.stopAccessingSecurityScopedResource() }
        
        let destinationURL = documentsURL.appendingPathComponent(url.lastPathComponent)
        
        do {
            // Remove existing file if it exists
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            try fileManager.copyItem(at: url, to: destinationURL)
            print("Successfully imported: \(url.lastPathComponent)")
        } catch {
            print("Error copying file: \(error.localizedDescription)")
        }
    }
    
    private func extractMetadata(from url: URL) async -> Song? {
        let asset = AVAsset(url: url)
        
        var title = url.deletingPathExtension().lastPathComponent
        var artist = "Unknown Artist"
        var album = "Unknown Album"
        var artwork: UIImage? = nil
        
        do {
            let metadata = try await asset.load(.metadata)
            
            for item in metadata {
                guard let commonKey = item.commonKey else { continue }
                
                switch commonKey {
                case .commonKeyTitle:
                    if let value = try? await item.load(.value) as? String {
                        title = value
                    }
                case .commonKeyArtist:
                    if let value = try? await item.load(.value) as? String {
                        artist = value
                    }
                case .commonKeyAlbumName:
                    if let value = try? await item.load(.value) as? String {
                        album = value
                    }
                case .commonKeyArtwork:
                    if let data = try? await item.load(.value) as? Data {
                        artwork = UIImage(data: data)
                    }
                default:
                    break
                }
            }
            
            return Song(
                id: url.lastPathComponent,
                title: title,
                artist: artist,
                albumTitle: album,
                artwork: artwork,
                fileURL: url
            )
        } catch {
            print("Error extracting metadata for \(url.lastPathComponent): \(error.localizedDescription)")
            // Fallback to basic info if metadata loading fails
            return Song(
                id: url.lastPathComponent,
                title: title,
                artist: artist,
                albumTitle: album,
                artwork: nil,
                fileURL: url
            )
        }
    }
}
