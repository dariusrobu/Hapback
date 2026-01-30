# Implementation Plan: Classic Playlists

## Phase 1: Music Library Expansion
- [x] Task: Update MusicLibraryService for Playlists a2321aa
    - [x] Add `fetchPlaylists()` method to `MusicLibraryService` using `MPMediaQuery.playlists()`.
    - [x] Create a `Playlist` model wrapper if needed to distinguish Smart Playlists.
- [~] Task: Conductor - User Manual Verification 'Music Library Expansion' (Protocol in workflow.md)

## Phase 2: Playlists View UI
- [ ] Task: Create PlaylistsView Component
    - [ ] Implement the UI layout in `PlaylistsView.swift` based on the Stitch design.
    - [ ] Apply the specific backlight color (#d8e9f0) and deep blue selection style.
    - [ ] Integrate the list with the fetched data from `MusicLibraryService`.
- [ ] Task: Bind Navigation and Wheel
    - [ ] Ensure `PlaylistsView` responds to click wheel ticks for selection.
    - [ ] Implement the center button action to navigate to a placeholder song list.
- [ ] Task: Conductor - User Manual Verification 'Playlists View UI' (Protocol in workflow.md)

## Phase 3: Visual Refinement
- [ ] Task: Refine LCD LCD Border and Typography
    - [ ] Match the 3px solid border and inner shadow for the Playlists LCD area.
    - [ ] Ensure the font matches the Chicago aesthetic defined in the spec.
- [ ] Task: Conductor - User Manual Verification 'Visual Refinement' (Protocol in workflow.md)
