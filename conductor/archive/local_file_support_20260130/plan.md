# Implementation Plan: Local File Playback Support

## Phase 1: Local File Discovery & Metadata [checkpoint: a2321aa]
- [x] Task: Create FileScannerService a2321aa
    - [x] Implement a service to scan the app's `Documents` directory for audio extensions (.mp3, .m4a, .wav).
    - [x] Create a `LocalSong` model or update the existing `Song` model to support file URLs.
- [x] Task: Implement Metadata Parsing a2321aa
    - [x] Use `AVMetadataItem` to extract ID3 tags and artwork from discovered files.
    - [x] Add unit tests for metadata extraction with sample file paths.
- [x] Task: Conductor - User Manual Verification 'Local File Discovery & Metadata' (Protocol in workflow.md)

## Phase 2: Library Integration [checkpoint: a2321aa]
- [x] Task: Update MusicLibraryService a2321aa
    - [x] Create a unified `fetchAllSongs()` method that combines `MediaPlayer` results and `FileScannerService` results.
    - [x] Ensure Artists and Albums are also aggregated from local file metadata.
- [x] Task: Update View Data Sources a2321aa
    - [x] Update `ContentView` and sub-views to use the unified library data.
- [x] Task: Conductor - User Manual Verification 'Library Integration' (Protocol in workflow.md)

## Phase 3: Playback Engine Updates [checkpoint: a2321aa]
- [x] Task: Enhance PlaybackManager for Local URLs a2321aa
    - [x] Update `PlaybackManager.play(_ song:)` to detect if a song has a local URL and load it accordingly.
    - [x] Ensure time observation and control logic work identically for both sources.
- [x] Task: Conductor - User Manual Verification 'Playback Engine Updates' (Protocol in workflow.md)
