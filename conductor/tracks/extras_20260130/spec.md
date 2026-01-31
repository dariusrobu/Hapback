# Specification: Extras (Clock, Games, and Tools)

## Overview
Implement the "Extras" sub-menu for Hapback, featuring a suite of utility and entertainment tools that mirror the 6th Generation iPod Classic experience. This includes a Clock, a Stopwatch, a Calendar, and the legendary "Brick" game.

## Functional Requirements
*   **Extras Menu:** Replace the "Extras" placeholder with a navigable list:
    -   Clock
    -   Games
    -   Stopwatch
    -   Calendars
*   **Clock View:** 
    -   A dedicated screen displaying the current time and date in large, bold digital text.
    -   Follows the iPod's high-contrast LCD aesthetic.
*   **Stopwatch View:**
    -   A functional digital stopwatch.
    -   Controls: Center button to Start/Stop, Menu button to Reset (when paused).
*   **Calendars View:**
    -   A simple grid view showing the current month.
    -   Uses the Chicago-inspired font for day labels.
*   **Games (Brick):**
    -   A sub-menu containing "Brick".
    -   **Brick Gameplay:** A breakout-style game where the player controls a paddle to bounce a ball and destroy blocks.
    -   **Controls:** Rotation of the click wheel moves the paddle left and right.

## UI Design
*   **Consistency:** All views must maintain the #d8e9f0 LCD backlight and #000080 selection color.
*   **Typography:** Maintain the Inter/Chicago bold font for all text and numbers.
*   **Navigation:** Deep integration with the existing navigation stack; ensure "MENU" pops the stack correctly from within games or tools.

## Acceptance Criteria
*   Navigating to "Extras" shows the functional list of tools.
*   The Clock displays the accurate system time.
*   The Stopwatch accurately tracks time and responds to click wheel button presses.
*   The Calendar displays the correct days for the current month.
*   "Brick" is playable, with the paddle responding smoothly to wheel rotation.

## Out of Scope
*   Alarm clock functionality (notifications).
*   Additional games beyond "Brick".
*   Calendar event syncing (view only).
