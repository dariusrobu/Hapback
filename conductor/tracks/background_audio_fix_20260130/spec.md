# Specification: Background Audio Stability Fix

## Overview
Address the issue where audio playback stops immediately when the app is minimized. Despite the "AirPlay" icon being visible, the system is suspending the app process. This track focuses on hardening the background audio session and ensuring the OS grants the app "Background Audio" priority.

## Functional Requirements
*   **Persistent Playback:** Music must continue playing through app transitions (Foreground -> Background -> Locked).
*   **Process Protection:** Implement robust background task assertions to prevent iOS from suspending the audio thread during track transitions.
*   **Session Hardening:** 
    -   Configure `AVAudioSession` with the `mixWithOthers` option disabled to claim exclusive audio focus.
    -   Ensure `MPNowPlayingInfoCenter` is populated *immediately* upon play to signal active engagement to the OS.
*   **Remote Command Reliability:** Verify all `MPRemoteCommandCenter` targets are strongly retained and correctly linked to the `AVPlayer` instance.

## Technical Details
*   **Audio Policy:** Maintain `.longFormAudio` but ensure it's set globally at app launch.
*   **Asset Loading:** Ensure `AVURLAsset` is initialized with `options: [AVURLAssetPreferPreciseDurationKey: true]` to prevent loading delays that might trigger a suspension.
*   **Lifecycle Handling:** Use `NotificationCenter` to re-verify the `AVAudioSession` state when the app enters the background.

## Acceptance Criteria
*   Starting a song and immediately swiping to the home screen results in zero audio dropout.
*   Locking the device while music is playing results in zero audio dropout.
*   Lock screen controls remain responsive and accurately reflect the metadata of the playing song.
*   The "Playback" icon in the Dynamic Island/Status Bar remains active as long as a song is playing or paused in the background.

## Out of Scope
*   External library (Apple Music/Spotify) integration—this fix is strictly for local `AVPlayer` files.
