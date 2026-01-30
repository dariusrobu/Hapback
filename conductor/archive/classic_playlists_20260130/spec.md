# Specification: Classic Playlists Implementation

## Overview
Implement the "Playlists" view for Hapback, strictly adhering to the Stitch design provided. This view allows users to browse their music playlists fetched from the system library using the virtual click wheel for navigation.

## Functional Requirements
*   **System Integration:** Use `MediaPlayer` to fetch all available playlists from the user's iOS Music Library.
*   **List Rendering:** Display a vertical list of playlists including:
    - Playlist Title
    - Navigation Chevron (on the right)
*   **Smart Playlists:** Visually distinguish between standard user playlists and system-defined Smart Playlists (e.g., using a subtle icon if possible).
*   **Navigation Logic:**
    - Selecting a playlist with the center button navigates the user to a detailed view of the songs within that playlist.
    - Pressing the "MENU" button on the click wheel returns the user to the Home Page.
*   **Click Wheel Integration:** Use the existing `ClickWheelView` and its tick publisher to drive selection within this menu.

## UI Design (Based on Stitch HTML)
*   **Backlight Color:** Precise blue-white background (#d8e9f0).
*   **LCD Border:** [3px] solid #848484 with inner shadow.
*   **Typography:** Chicago-inspired font (Inter bold fallback) for titles and header.
*   **Selection Style:** Selected items use the deep blue (#000084) background with white text.
*   **Header Bar:** "Playlists" centered, uppercase, with a battery icon on the right.

## Acceptance Criteria
*   The Playlists view correctly fetches and displays the user's library playlists.
*   The virtual click wheel accurately scrolls through the playlists.
*   The visual styling matches the provided Stitch design (blue-white LCD, deep blue selection).
*   Selecting a playlist navigates to a (placeholder) song list for that playlist.
*   Menu button returns to the home screen.

## Out of Scope
- Implementing the detailed "Songs within Playlist" view logic (beyond a simple list/placeholder).
- Editing or creating playlists within the app.
