# Specification: Music Playback and Now Playing View

## Overview
Implement the full music playback engine and the "Now Playing" view for Hapback. This track transforms the app from a visual prototype into a functional audio player, using AVFoundation for high-fidelity playback and the virtual click wheel for comprehensive control.

## Functional Requirements
*   **Playback Engine:** Implement an `AudioManager` using `AVQueuePlayer` (part of AVFoundation) to handle playback of local files.
*   **Audio Control Logic:**
    -   **Play/Pause:** Controlled by the center button.
    -   **Skip Forward/Back:** Controlled by the side buttons.
    -   **Fast Forward/Rewind:** Triggered by long-pressing the side buttons.
    -   **Volume Control:** Drive system volume using the rotation of the click wheel when in the Now Playing view.
*   **Now Playing UI (Based on Stitch HTML):**
    -   **Album Artwork:** High-resolution display of the current track's artwork.
    -   **Metadata Display:** Song title, artist name, and album title in the Chicago-inspired font.
    -   **Playback Progress:** Implement the "Diamond Slider" progress bar with elapsed and remaining time labels.
    -   **Status Bar:** "Now Playing" header with playback and battery status icons.

## Technical Details
*   **Framework:** `AVFoundation` for playback; `MediaPlayer` for system volume control (`MPVolumeView` or `MPMusicPlayerController.applicationMusicPlayer`).
*   **State Management:** Use a shared `PlaybackManager` (ObservableObject) to coordinate audio state across views.
*   **Time Tracking:** Set up a periodic time observer on the `AVPlayer` to update the UI progress bar.

## Acceptance Criteria
*   Selecting a song from the library starts actual audio playback.
*   The "Now Playing" view correctly displays the current song's artwork and metadata.
*   The virtual click wheel buttons (Center, Forward, Rewind) control playback as expected.
*   Rotating the wheel in the Now Playing view adjusts the volume.
*   The diamond slider moves in sync with the audio progress.

## Out of Scope
*   Advanced equalizer (EQ) settings.
*   Visualizers (like the oscilloscope).
*   Scrubbing by rotating the wheel (volume is the priority for this track).
