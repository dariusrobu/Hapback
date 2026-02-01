# Hapback

Hapback is a native iOS application built using **Swift** and **SwiftUI** that provides a focused, offline-first music experience. It honors the tactile legacy of the 2000s by transforming the modern iPhone into a dedicated high-fidelity music player using a haptic-driven virtual click wheel.

## 📱 Product Vision

To provide a distraction-free, high-fidelity music environment for nostalgia seekers, digital minimalists, and audiophiles. Hapback focuses on playing user-owned local file libraries (MP3, AAC, ALAC, WAV, AIFF) with a unique tactile interface.

## ✨ Key Features

- **Virtual Click Wheel**: 
  - Rotary tracking for list navigation.
  - Haptic mapping via iOS Taptic Engine for a physical "click" sensation.
  - Classic button quadrants: Menu, Play/Pause, Forward/Back, and Center Select.
- **Library Management**:
  - Offline-first: Files stored within the app sandbox.
  - Import from iOS Files App (Local/iCloud Drive).
  - Metadata engine for ID3 tags and high-resolution album art.
- **Audio Playback**:
  - Support for high-quality formats (FLAC, ALAC, etc.).
  - Gapless playback for seamless transitions.
  - Background audio with Control Center and Lock Screen integration.
- **Classic UI**:
  - Top "LCD" screen mimicking classic displays.
  - Interactive wheel taking up the bottom portion of the screen.
  - Dynamic Themes (Classic White, Stealth Black, Special Edition Red/Black).

## 🛠 Technology Stack

- **Language**: Swift 5.10+
- **UI Framework**: SwiftUI + UIKit (for advanced gesture recognition)
- **Haptics**: Core Haptics (CHHapticEngine)
- **Data Persistence**: SwiftData / Core Data
- **Audio Engine**: AVFoundation
- **Platform**: iOS 16.0+

## 📂 Project Structure

- `Hapback/Hapback/`: Main application source code.
  - `Components/`: Reusable UI components like the `ClickWheelView`.
  - `Models/`: Data models (Album, Artist, Song, etc.).
  - `Services/`: Logic for audio playback, haptics, and file scanning.
  - `Views/`: Application screens and navigation.
- `Hapback/HapbackTests/`: Unit and Logic tests.
- `Hapback/HapbackUITests/`: UI interaction tests.
- `conductor/`: Project management and track-based development documentation.

## 🚀 Getting Started

### Prerequisites

- macOS with the latest version of **Xcode** (15.0+ recommended).
- A physical iPhone is recommended to experience the Haptic feedback.

### Installation

1. Clone the repository.
2. Open `Hapback/Hapback.xcodeproj` in Xcode.

### Running

1. Select a target (Simulator or connected iOS device).
2. Press `Cmd + R` to build and run the application.

## 🧪 Testing

- **Unit Tests**: Open the Test Navigator (`Cmd + 6`) or press `Cmd + U` to run all tests.
- **UI Tests**: Located in the `HapbackUITests` target.

## 📜 Coding Conventions

- **SwiftUI**: Use declarative patterns and small, reusable components.
- **SwiftData**: Use `@Model` for persistence and `@Query` for data-driven views.
- **Haptics**: Always use `HapticManager` for consistent feedback across the UI.
- **Concurrency**: Use `async/await` and `@MainActor` for thread-safe UI updates.

---
*Legal Note: Hapback is a tool for playing user-owned files and does not provide music content.*
