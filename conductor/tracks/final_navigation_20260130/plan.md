# Implementation Plan: Final Navigation and Data Polish

## Phase 1: Filtered Data Services [checkpoint: 51150]
- [x] Task: Update MusicLibraryService for Filtering $(git log -1 --format="%H")
    - [x] Add `fetchAlbums(for artist:)` and `fetchSongs(for album:)` methods.
    - [x] Ensure local files are correctly included in these filtered results.
- [x] Task: Storage Calculation Helper $(git log -1 --format="%H")
    - [x] Implement a method to calculate total disk space used by the `Documents` folder.
- [x] Task: Conductor - User Manual Verification 'Filtered Data Services' (Protocol in workflow.md)

## Phase 2: Navigation Hierarchy [checkpoint: a5f1964]
- [x] Task: Implement Artist & Album Detail Views a5f1964
    - [x] Create `ArtistDetailView` (listing albums) and `AlbumDetailView` (listing songs).
    - [x] Update `ContentView` navigation logic to support nested destinations.
- [x] Task: Refine Navigation Stack a5f1964
    - [x] Ensure `selectedIndex` is reset correctly upon entering/exiting sub-menus.
    - [x] Fix the "MENU" button logic to pop only the last item from the stack.
- [x] Task: Conductor - User Manual Verification 'Navigation Hierarchy' (Protocol in workflow.md)

## Phase 3: Settings & Final Polish [checkpoint: a5f1964]
- [x] Task: Implement Settings/Storage UI a5f1964
    - [x] Replace the Settings placeholder with a real list showing song count and storage size.
- [x] Task: Global Bug Scrub a5f1964
    - [x] Verify selection scrolling behavior in all new nested lists.
    - [x] Check for any remaining placeholder text in core music views.
- [x] Task: Conductor - User Manual Verification 'Settings & Final Polish' (Protocol in workflow.md)
