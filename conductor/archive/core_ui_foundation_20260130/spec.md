# Specification: Core iPod UI Foundation

## Goal
Implement the foundational user interface for Hapback, mimicking the iPod Classic (6th Gen) aesthetic and interaction model. This includes a functional virtual click wheel, high-fidelity haptics, and basic music library integration.

## Scope
*   **Virtual Click Wheel:** A touch-interactive wheel that detects circular gestures.
*   **Haptic Feedback:** Precise "clicks" triggered by wheel rotation using Core Haptics.
*   **Classic UI Layout:** A split-screen or layered view with a display area at the top and the click wheel at the bottom.
*   **Music Library Integration:** Accessing the local device music library via `MediaPlayer` or `MusicKit`.
*   **Navigation Logic:** Basic menu scrolling (Songs, Artists, Albums) driven by the wheel.

## Technical Details
*   **Framework:** SwiftUI
*   **Feedback:** Core Haptics for tactile response; AVFoundation for click sounds.
*   **Music Data:** `MPMediaQuery` or `MusicKit` for retrieving library items.
*   **Interactions:** `DragGesture` with angular math for wheel rotation detection.

## Success Criteria
*   User can rotate the virtual wheel and feel/hear distinct "clicks."
*   Rotating the wheel scrolls through a list of songs from the local library.
*   The UI matches the 6th Gen iPod glossy aesthetic.
