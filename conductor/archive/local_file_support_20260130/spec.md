# Specification: Local File Playback Support

## Overview
Enable playback of audio files stored in the "Files" app. The app will automatically scan its local "Documents" folder for supported audio formats (MP3, AAC, ALAC, WAV, etc.) and integrate them into the existing music library views (Artists, Albums, Songs).

## Functional Requirements
*   **Folder Scanning:** Implement a service to monitor and scan the app's `Documents` directory for audio files.
*   **Metadata Extraction:** For every found file, use `AVAsset` to extract:
    - Song Title
    - Artist Name
    - Album Title
    - High-Resolution Artwork
*   **Library Integration:** Merge these local files with any existing system music results so they appear in the main "Songs", "Artists", and "Albums" lists.
*   **Playback Support:** Ensure `PlaybackManager` can handle local `URL` paths in addition to system `MPMediaItem` references.

## UI Design
*   **File Access:** Users can drop files into the "Hapback" folder within the Files app.
*   **Visual Indicators:** (Optional) Add a subtle icon to identify local files vs. system library songs.

## Acceptance Criteria
*   Dropping an MP3/ALAC file into the app's Documents folder makes it appear in the "Songs" list.
*   The app correctly identifies the artist and album from the file's ID3 tags.
*   Selecting a local file starts playback in the `PlaybackManager`.
*   Artwork for local files is displayed in the "Now Playing" view.

## Out of Scope
*   Streaming support (e.g. Dropbox/Google Drive direct streaming).
*   In-app file management (deleting or moving files).
