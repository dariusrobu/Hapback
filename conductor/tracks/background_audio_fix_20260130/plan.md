# Implementation Plan: Background Audio Stability Fix

## Phase 1: Session & Info Center Hardening [checkpoint: 773e045]
- [x] Task: Refine Global Audio Session Config 773e045
    - [x] Update `PlaybackManager` to configure `AVAudioSession` with `.longFormAudio` policy and ensure `mixWithOthers` is disabled.
    - [x] Ensure the session is initialized exactly once at app launch via `init`.
- [x] Task: Immediate Metadata Registration 773e045
    - [x] Modify `playCurrentIndex` to call `updateNowPlayingInfo()` *before* calling `player?.play()`.
    - [x] Verify that the system registers the "Now Playing" session immediately upon song selection.
- [x] Task: Conductor - User Manual Verification 'Session & Info Center Hardening' (Protocol in workflow.md)

## Phase 2: Process Protection & Asset Loading [checkpoint: 23d3bed]
- [x] Task: Robust Background Task Management 23d3bed
    - [x] Implement a persistent background task identifier that is only invalidated after a successful playback start event.
    - [x] Add logging to track background task expiration and renewal.
- [x] Task: Optimize Asset Initialization 23d3bed
    - [x] Update `AVURLAsset` creation to use `[AVURLAssetPreferPreciseDurationKey: true]` to prevent initialization hangs in the background.
- [x] Task: Conductor - User Manual Verification 'Process Protection & Asset Loading' (Protocol in workflow.md)

## Phase 3: Lifecycle Re-Assertion [checkpoint: 21c491b]
- [x] Task: Background Notification Handlers 21c491b
    - [x] Add an observer for `UIApplication.didEnterBackgroundNotification` in `PlaybackManager`.
    - [x] In the handler, explicitly re-verify `AVAudioSession.sharedInstance().setActive(true)` to prevent suspension.
- [x] Task: Final Stability Test 21c491b
    - [x] Test transitions: Foreground -> Background -> Locked -> Unlock -> Foreground.
- [x] Task: Conductor - User Manual Verification 'Lifecycle Re-Assertion' (Protocol in workflow.md)
