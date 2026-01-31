# Specification: Final Navigation and Data Polish

## Overview
Complete the core navigation hierarchy of Hapback, transforming it from a flat menu system into a fully navigable music explorer. This track implements the "Drill-down" logic for Artists and Albums and populates the Settings view with real device data.

## Functional Requirements
*   **Navigation Drill-down:**
    -   **Artist View:** Selecting an artist now navigates to a new `ArtistDetailView` showing only that artist's albums.
    -   **Album View:** Selecting an album navigates to an `AlbumDetailView` showing the songs in that album.
    -   **Breadcrumbs:** Ensure the "MENU" button correctly pops the navigation stack one level at a time.
*   **Settings Integration:**
    -   Implement a functional **About** or **Storage** section within Settings.
    -   Calculate and display: Total number of songs, total storage used by imported files, and app version.
*   **Data Plumbing:**
    -   Update `MusicLibraryService` to support filtered queries (e.g., `fetchAlbums(for artist:)`, `fetchSongs(for album:)`).
    -   Ensure local files are correctly grouped into these filtered views using their extracted metadata.

## UI Design
*   **Detail Views:** Follow the established list pattern but with context-specific headers (e.g., the name of the Artist or Album).
*   **Consistency:** Maintain the #000080 selection blue and Chicago-inspired font across all new sub-views.

## Acceptance Criteria
*   Selecting "The Beatles" in Artists shows only Beatles albums.
*   Selecting "Abbey Road" in Albums shows the tracklist for that album.
*   Selecting a song from a filtered list starts playback correctly in the `PlaybackManager`.
*   The Settings view correctly displays the count of songs currently in the library.
*   The "MENU" button behaves exactly like a physical iPod, backing out one level per click.

## Out of Scope
*   Implementing Games (Music Quiz, Brick, etc.) in the Extras menu.
*   Search functionality.
