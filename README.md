# Meta Contextual Notes

**Context-aware notes for Meta AI Glasses — capture with voice, location, and time; recall when context matches.**

---

A Meta AI Glasses (Ray-Ban Meta) companion app that captures notes with rich context—voice, location, time, and optional triggers—and surfaces them when that context becomes relevant. Notes are situation-aware instead of static.

## Key Features

- **Voice capture** via Meta Wearables DAT SDK
- **Contextual storage** — time, location, and place automatically attached
- **Smart triggers** — "Remind me when I get to the station" or "Remind me at 3pm"
- **Hands-free** — capture and recall entirely by voice on glasses
- **Geofence-based recall** — notes surface when you enter a saved location

## Tech Stack

| Component | Technology |
|-----------|------------|
| Platform | iOS 17.0+ |
| Language | Swift 6 |
| UI | SwiftUI |
| Glasses | Meta Wearables DAT SDK |
| Persistence | SwiftData / Core Data |
| Location | Core Location |

## Project Structure

```
meta-contextual-notes/
├── ContextualNotes/           # Main iOS app target
│   ├── App/                   # App entry, lifecycle
│   ├── Models/                # Note, Trigger data models
│   ├── Services/
│   │   ├── NoteCaptureService # Record, transcribe, save
│   │   ├── NoteRecallService  # Query by context
│   │   ├── LocationService    # Core Location, geofencing
│   │   ├── MetaDATService     # Glasses pairing, audio I/O
│   │   └── TriggerMonitor    # Time + location triggers
│   ├── Views/
│   │   ├── PairingView
│   │   ├── HomeView
│   │   ├── NotesListView
│   │   ├── NoteDetailView
│   │   └── SettingsView
│   └── Resources/
├── docs/
│   └── SCOPE.md               # Full scope & spec document
└── README.md
```

## Getting Started

1. **Generate Xcode project** (requires [XcodeGen](https://github.com/yonaskolb/XcodeGen)):
   ```bash
   brew install xcodegen
   xcodegen generate
   ```
2. Open `ContextualNotes.xcodeproj` in Xcode
3. Select your development team in Signing & Capabilities (for device runs)
4. Add Meta Wearables DAT SDK dependency when available
5. Run on Simulator or device (glasses pairing requires physical hardware)

## Branding

Shared branding with other Omnia Meta glasses apps:
- **Glasses** / **RayBanGlasses** — Ray-Ban Meta imagery (from [Meta-Browser-Commerce](https://github.com/AldoOmnia/Meta-Browser-Commerce), [CTA Transit Assistant](https://github.com/AldoOmnia/mobile_Meta_app_CTA_smart_glasses))
- **OmniaLogo** — "Powered by Omnia" footer
- **AppTheme** — Dark theme, accent colors, typography (aligned with CTA & Browser Commerce)

## Documentation

See [docs/SCOPE.md](docs/SCOPE.md) for the complete scope document including user stories, data models, voice phrases, and phased roadmap.

## License

Proprietary — Meta / Aldo Omnia
