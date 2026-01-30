# Specification: Classic Home Page Implementation

## Overview
Implement the "Home" or "Main Menu" view for Hapback, strictly adhering to the Stitch design provided. This view serves as the primary navigation hub, allowing users to select different sections of their music library and settings using the virtual click wheel.

## Functional Requirements
*   **Classic Menu List:** Implement a vertical list containing the following items:
    - Playlists
    - Artists
    - Albums
    - Songs
    - Extras
    - Settings
    - Now Playing (Conditional)
*   **Navigation Logic:** Selecting a menu item should navigate the user to the corresponding view (initially using placeholders where necessary).
*   **Contextual "Now Playing":** The "Now Playing" item should only be visible when there is an active audio session (music is loaded or playing).
*   **Highlighting:** When music is playing, the "Now Playing" item should exhibit a distinct visual state (e.g., specific background color or icon) to signify activity.
*   **Click Wheel Integration:** Use the existing `ClickWheelView` and its tick publisher to drive selection within this menu.

## UI Design (Based on Stitch HTML)
*   **Header Bar:** Displays "Hapback" centered in the Chicago-inspired font, with playback and battery icons.
*   **LCD Styling:** Gradient background (#f0f8ff to #e6f0ff) with inner shadow and rounded corners.
*   **List Items:** High-contrast text with chevron icons on the right. Selected items use the primary blue (#000080) background with white text.
*   **Layout:** Maintains the 50/50 split between the LCD display and the Click Wheel.

## Acceptance Criteria
*   The Home Page menu renders correctly with all specified items.
*   The virtual click wheel accurately scrolls through the menu items.
*   Pressing the center button on a menu item triggers navigation (or a console log for placeholder views).
*   The "Now Playing" item appears/disappears based on audio state.
*   The visual styling matches the provided Stitch design precisely.

## Out of Scope
*   Implementing the full functionality of every sub-menu (Artists, Albums, etc.) in this specific track.
*   Persistent data storage for settings.
