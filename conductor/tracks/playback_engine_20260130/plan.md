# Implementation Plan: Music Playback and Now Playing View

## Phase 1: Playback Engine & State Management
- [x] Task: Implement PlaybackManager a2ca201
    - [x] Create `PlaybackManager.swift` as an `ObservableObject` to hold current song, progress, and playback state.
    - [x] Set up `AVQueuePlayer` and `AVPlayerItem` logic for local file playback.
    - [x] Add a periodic time observer to publish playback progress.
- [~] Task: Unit Tests for Playback Logic
    - [ ] Write tests to verify play/pause toggling and track skipping state changes.
- [ ] Task: Conductor - User Manual Verification 'Playback Engine & State Management' (Protocol in workflow.md)

## Phase 2: Now Playing UI
- [ ] Task: Implement NowPlayingView
    - [ ] Create the view layout matching the Stitch design (Artwork, Metadata, Progress).
    - [ ] Implement the `DiamondSlider` as a custom progress bar component.
    - [ ] Format time strings (M:SS) for elapsed and remaining labels.
- [ ] Task: Integrate Artwork Fetching
    - [ ] Add a helper to extract and scale high-res artwork from `MPMediaItem`.
- [ ] Task: Conductor - User Manual Verification 'Now Playing UI' (Protocol in workflow.md)

## Phase 3: Click Wheel Integration
- [ ] Task: Map Buttons to Playback Controls
    - [ ] Update `ContentView` to pass `PlaybackManager` actions to the `ClickWheelView` button handlers.
    - [ ] Implement long-press gesture for seeking (Fast Forward/Rewind).
- [ ] Task: Implement Volume Control
    - [ ] Bind Click Wheel rotation to system volume using `MPVolumeView` or `MPMusicPlayerController`.
- [ ] Task: Conductor - User Manual Verification 'Click Wheel Integration' (Protocol in workflow.md)
