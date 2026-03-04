iOS Demo Player (AVPlayer + AirPlay + Background Audio)

Overview
- This demo is a minimal iOS project skeleton to test AVPlayer playback, AirPlay routing, and background audio behavior.
- It uses a remote mp4 test URL (public) to avoid YouTube TOS issues. Use a real device and an AirPlay receiver (Apple TV) for testing.

Files
- AppDelegate.swift
- SceneDelegate.swift
- ViewController.swift
- QueueManager.swift
- Info.plist (snippet)
- Main.storyboard (xml placeholder)

How to run
1. Open Xcode and create a new iOS project (App) using the same bundle identifier you prefer.
2. Replace the generated files with the Swift files from this folder and update Info.plist with the snippet below.
3. In Signing & Capabilities, enable Background Modes -> Audio, AirPlay, and set any provisioning profiles as needed.
4. Build and run on a physical iOS device (AirPlay testing on Simulator is limited).

Test steps
- Launch the app on device.
- Tap Play to start sample mp4 playback.
- Tap the AirPlay button to select an Apple TV.
- While playback is on the external screen, return to the app and perform UI actions (add queue items, search). Playback should continue.
- Lock the device or press Home — audio should continue if Background Modes are enabled.

Notes
- This is a sample skeleton for functional testing. For production, handle errors, edge cases, secure network access, and comply with media source TOS.

Sample test media URL
- https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4
