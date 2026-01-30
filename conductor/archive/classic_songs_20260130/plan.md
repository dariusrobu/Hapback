# Implementation Plan: Classic Songs

## Phase 1: Music Library Enhancement [checkpoint: 949f949]
- [x] Task: Create Song Model 949f949
    - [x] Define `Song` struct with properties for persistent ID, title, and artist.
    - [x] Write unit tests for `Song` initialization from `MPMediaItem`.
- [x] Task: Update MusicLibraryService 949f949
    - [x] Ensure `fetchSongs()` returns the new `[Song]` model instead of raw items.
    - [x] Verify data fetching with unit tests.
- [x] Task: Conductor - User Manual Verification 'Music Library Enhancement' (Protocol in workflow.md)

## Phase 2: Songs View UI Implementation [checkpoint: 949f949]
- [x] Task: Create SongsView Component 949f949
    - [x] Implement the UI layout in `SongsView.swift` following the established LCD patterns.
    - [x] Create `SongListItem` component featuring the title and artist name.
- [x] Task: Integrate Navigation and Click Wheel 949f949
    - [x] Update `ContentView` to render `SongsView` and pass the selection binding.
    - [x] Implement the center button action to trigger playback (mock) and navigate to the `nowPlaying` destination.
- [x] Task: Conductor - User Manual Verification 'Songs View UI Implementation' (Protocol in workflow.md)

## Phase 3: Visual Polish [checkpoint: 949f949]
- [x] Task: Refine Typography and Performance 949f949
    - [x] Ensure the "Chicago" font aesthetic is applied correctly.
    - [x] Optimize the list rendering for large music libraries (e.g., using `LazyVStack` if necessary).
- [x] Task: Conductor - User Manual Verification 'Visual Polish' (Protocol in workflow.md)
