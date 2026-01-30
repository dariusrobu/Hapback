# Specification: Classic Artists Implementation

## Overview
Implement the "Artists" view for Hapback, strictly adhering to the Stitch design provided. This view allows users to browse their music collection by artist, fetched from the system library using the virtual click wheel for navigation.

## Functional Requirements
*   **System Integration:** Use `MediaPlayer` to fetch all available artists from the user's iOS Music Library.
*   **List Rendering:** Display a vertical list of artists including:
    - Artist Name
    - Artist Thumbnail (if available in system metadata)
    - Navigation Chevron (on the right)
*   **Navigation Logic:**
    - Selecting an artist with the center button navigates the user to a list of all songs by that specific artist.
    - Pressing the "MENU" button on the click wheel returns the user to the previous view (Home Page).
*   **Click Wheel Integration:** Use the existing `ClickWheelView` and its tick publisher to drive selection within this menu.

## UI Design (Based on Stitch HTML)
*   **Background:** Glossy polycarbonate gradient (White -> #e6e6e6).
*   **LCD Styling:** Gradient from #f0f8ff to #e6f0ff with inset shadow.
*   **LCD Border:** [3px] solid #848484 or similar subtle border.
*   **Typography:** Chicago-inspired font (Inter bold fallback) for titles and header.
*   **Selection Style:** Selected items use the primary blue (#000080) background with white text.
*   **Header Bar:** "Artists" centered, uppercase, with playback and battery icons.

## Acceptance Criteria
*   The Artists view correctly fetches and displays the user's library artists.
*   The virtual click wheel accurately scrolls through the artist list.
*   The visual styling matches the provided Stitch design precisely.
*   Selecting an artist navigates to a (placeholder) song list for that artist.
*   Menu button correctly returns to the previous screen.

## Out of Scope
*   Implementing the detailed "Songs by Artist" view logic (beyond a simple placeholder).
*   Advanced sorting (e.g., sort by album count or release date).
