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
