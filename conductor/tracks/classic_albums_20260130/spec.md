# Specification: Classic Albums Implementation

## Overview
Implement the "Albums" view for Hapback, strictly adhering to the classic iPod design patterns. This view allows users to browse their music collection by album, fetched from the system library using the virtual click wheel for navigation.

## Functional Requirements
*   **System Integration:** Use `MediaPlayer` to fetch all available albums from the user's iOS Music Library.
*   **List Rendering:** Display a vertical list of albums including:
    - Album Title
    - Album Artwork Thumbnail (fetched from system metadata)
    - Navigation Chevron (on the right)
*   **Navigation Logic:**
    - Selecting an album with the center button navigates the user to a list of all songs within that specific album.
    - Pressing the "MENU" button on the click wheel returns the user to the Home Page.
*   **Click Wheel Integration:** Use the existing `ClickWheelView` and its tick publisher to drive selection within this menu.

## UI Design
*   **Background:** Glossy polycarbonate gradient (consistent with other views).
*   **LCD Styling:** Gradient from #f0f8ff to #e6f0ff with inset shadow and 3px #848484 border.
*   **Typography:** Chicago-inspired font (Inter bold fallback) for titles and header.
*   **Selection Style:** Selected items use the primary blue (#000080) background with white text.
*   **Header Bar:** "Albums" centered, uppercase, with playback and battery icons.

## Acceptance Criteria
*   The Albums view correctly fetches and displays the user's library albums.
*   The virtual click wheel accurately scrolls through the album list.
*   Album artwork thumbnails are displayed correctly for each item.
*   The visual styling matches the established classic aesthetic of the app.
*   Selecting an album navigates to a (placeholder) song list for that album.
*   Menu button correctly returns to the home screen.

## Out of Scope
*   Implementing the detailed "Songs within Album" view logic (beyond a simple placeholder).
*   Advanced sorting or searching within the album list.
