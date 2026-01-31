# Implementation Plan: Extras (Clock, Games, and Tools)

## Phase 1: Extras Foundations & Utilities [checkpoint: e901de5]
- [x] Task: Implement Extras Sub-Menu e901de5
    - [x] Update `MenuDestination` and `ContentView` to support Extras navigation.
    - [x] Create `ExtrasMenuView` with options for Clock, Games, Stopwatch, and Calendars.
- [x] Task: Implement Clock View e901de5
    - [x] Create `ClockView.swift` displaying real-time digital clock and date.
- [x] Task: Implement Calendar View e901de5
    - [x] Create `CalendarView.swift` showing a grid of the current month.
- [x] Task: Conductor - User Manual Verification 'Extras Foundations & Utilities' (Protocol in workflow.md)

## Phase 2: Stopwatch Logic & UI [checkpoint: e901de5]
- [x] Task: Write Unit Tests for Stopwatch e901de5
    - [x] Define tests for start, stop, and reset logic in a `StopwatchViewModel`.
- [x] Task: Implement Stopwatch View e901de5
    - [x] Create `StopwatchView.swift` with formatted MM:SS.hh display.
    - [x] Bind center button to toggle and menu button to reset.
- [x] Task: Conductor - User Manual Verification 'Stopwatch' (Protocol in workflow.md)

## Phase 3: Brick Game Implementation [checkpoint: e901de5]
- [x] Task: Implement Brick Game Engine e901de5
    - [x] Create `BrickGameView.swift` with basic physics (ball bouncing, paddle movement).
    - [x] Define game state (score, lives, block grid).
- [x] Task: Integrate Click Wheel Controls e901de5
    - [x] Bind `ClickWheelView` rotation ticks to paddle horizontal position.
- [x] Task: Conductor - User Manual Verification 'Brick Game' (Protocol in workflow.md)
