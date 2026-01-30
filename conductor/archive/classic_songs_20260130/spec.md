# Specification: Classic Songs Implementation

## Overview
Implement the "Songs" view for Hapback, strictly adhering to the Stitch design provided. This view allows users to browse their entire music library song by song, fetched from the system library using the virtual click wheel for navigation.

## Functional Requirements
*   **System Integration:** Use `MediaPlayer` to fetch all available songs from the user's iOS Music Library.
*   **List Rendering:** Display a vertical list of songs including:
    - Song Title
    - Artist Name (displayed below the title for clarity)
*   **Navigation Logic:**
    - Selecting a song with the center button starts playback of that song and navigates the user to the **Now Playing** view.
    - Pressing the "MENU" button on the click wheel returns the user to the Home Page.
*   **Click Wheel Integration:** Use the existing `ClickWheelView` and its tick publisher to drive selection within this list.

## UI Design (Based on Stitch HTML)
*   **Backlight Color:** Consistent with previous views (#f0f8ff to #e6f0ff).
*   **LCD Border:** [3px] solid #848484 with inner shadow.
*   **Typography:** Chicago-inspired font (Inter bold fallback) for titles and header.
*   **Selection Style:** Selected items use the primary blue (#000080) background with white text.
*   **Header Bar:** "Songs" centered, uppercase, with playback and battery icons.

## Acceptance Criteria
*   The Songs view correctly fetches and displays all songs from the user's library.
*   The virtual click wheel accurately scrolls through the song list.
*   The visual styling matches the provided Stitch design and established app patterns.
*   Selecting a song triggers playback and navigates to the (placeholder) Now Playing view.
*   Menu button correctly returns to the previous screen.

## Out of Scope
*   Implementing the full **Now Playing** playback engine details (beyond triggering the start and navigation).
*   Advanced list features like searching or alphabet jumps.
