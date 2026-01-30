# Implementation Plan: Classic Home Page

## Phase 1: Data Models & Scaffolding [checkpoint: eb98bf2]
- [x] Task: Create Menu Item Model 41688cb
    - [x] Define `MenuItem` struct with properties for title, icon, and destination type.
    - [x] Create a static data source with the standard iPod menu items (Playlists, Artists, Albums, Songs, Extras, Settings, Now Playing).
- [x] Task: Conductor - User Manual Verification 'Data Models & Scaffolding' (Protocol in workflow.md)

## Phase 2: Home Page UI Implementation [checkpoint: 2dcd317]
- [x] Task: Update ContentView Layout 0bdc04c
    - [x] Refactor `ContentView` to use the `MenuItem` model.
    - [x] Ensure the "Now Playing" item is conditionally shown (mock the condition for now).
    - [x] Apply the specific visual styles from the specification (header, gradient background, list styling).
- [x] Task: Implement Navigation Logic c9aa569
    - [x] Set up a `NavigationStack` or custom view switcher driven by the `ClickWheelView` selection.
    - [x] Create placeholder views for each menu destination (Playlists, Artists, etc.).
- [x] Task: Conductor - User Manual Verification 'Home Page UI Implementation' (Protocol in workflow.md)

## Phase 3: Click Wheel Integration & Polish [checkpoint: 2dcd317]
- [x] Task: Connect Click Wheel to Menu c9aa569
    - [x] Ensure the existing `ClickWheelViewModel` drives the selection index of the new menu list.
    - [x] Verify scrolling behavior and bounds checking.
- [x] Task: Visual Polish & Assets 0bdc04c
    - [x] Add the specific icons (battery, play arrow, chevrons) matching the design.
    - [x] Fine-tune fonts (Chicago/Inter) and colors to match the "glossy polycarbonate" aesthetic.
- [x] Task: Conductor - User Manual Verification 'Click Wheel Integration & Polish' (Protocol in workflow.md)
