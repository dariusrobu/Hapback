# Implementation Plan: Music Playback and Now Playing View

## Phase 1: Playback Engine & State Management [checkpoint: 470b6ba]
- [x] Task: Implement PlaybackManager a2ca201
    - [x] Create `PlaybackManager.swift` as an `ObservableObject` to hold current song, progress, and playback state.
    - [x] Set up `AVQueuePlayer` and `AVPlayerItem` logic for local file playback.
    - [x] Add a periodic time observer to publish playback progress.
- [x] Task: Unit Tests for Playback Logic 1fcf635
    - [x] Write tests to verify play/pause toggling and track skipping state changes.
- [x] Task: Conductor - User Manual Verification 'Playback Engine & State Management' (Protocol in workflow.md)

## Phase 2: Now Playing UI
- [x] Task: Implement NowPlayingView 77b3c05
    - [x] Create the view layout matching the Stitch design (Artwork, Metadata, Progress).
    - [x] Implement the `DiamondSlider` as a custom progress bar component.
    - [x] Format time strings (M:SS) for elapsed and remaining labels.
- [x] Task: Integrate Artwork Fetching 77b3c05
    - [x] Add a helper to extract and scale high-res artwork from `MPMediaItem`.
- [~] Task: Conductor - User Manual Verification 'Now Playing UI' (Protocol in workflow.md)

## Phase 3: Click Wheel Integration [checkpoint: 1047a1e]
- [x] Task: Map Buttons to Playback Controls 6eea7b9
    - [x] Update `ContentView` to pass `PlaybackManager` actions to the `ClickWheelView` button handlers.
    - [x] Implement long-press gesture for seeking (Fast Forward/Rewind).
- [x] Task: Implement Volume Control 1047a1e
    - [x] Bind Click Wheel rotation to system volume using `MPVolumeView` or `MPMusicPlayerController`.
- [~] Task: Conductor - User Manual Verification 'Click Wheel Integration' (Protocol in workflow.md)
