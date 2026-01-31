# Specification: Background Audio and Lock Screen Controls

## Overview
Enable high-fidelity background audio playback for Hapback, allowing music to continue playing when the app is minimized or the device is locked. This track also integrates with `MPNowPlayingInfoCenter` and `MPRemoteCommandCenter` to provide standard iOS Lock Screen and Control Center playback controls.

## Functional Requirements
*   **Background Audio:** Update the app's capability to support audio playback in the background.
*   **Now Playing Metadata:** Synchronize current song metadata (Title, Artist, Album, Artwork) with the iOS `MPNowPlayingInfoCenter`.
*   **Remote Commands:** Implement handlers for standard iOS remote commands:
    -   Play / Pause
    -   Next Track / Previous Track
    -   Seeking (Scrubbing)
*   **Audio Session Management:**
    -   Handle audio interruptions (e.g., phone calls) by pausing playback and requiring a manual resume (as per user preference).
    -   Properly configure the `AVAudioSession` category and active state.

## Technical Details
*   **Capabilities:** Enable the `Audio, AirPlay, and Picture in Picture` background mode in the Xcode project.
*   **Frameworks:** `AVFoundation` for session management and `MediaPlayer` for remote controls.
*   **State Coordination:** The `PlaybackManager` will serve as the bridge between internal playback state and the system's "Now Playing" info.

## Acceptance Criteria
*   Music continues to play when the user presses the Home button or locks their iPhone.
*   The correct song title, artist, and artwork appear on the iOS Lock Screen and Control Center.
*   The Play/Pause and Skip buttons on the Lock Screen correctly control the app's playback.
*   Incoming calls pause the music, and playback remains paused after the call ends (Manual Resume).

## Out of Scope
*   AirPlay 2 advanced integration (multi-room control).
*   Bluetooth accessory metadata customization (e.g., custom car head unit display beyond standard).
