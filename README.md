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
| Platform | iOS 15.2+ |
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

1. Clone the repository
2. Open in Xcode (create a new iOS app project or use existing)
3. Add Meta Wearables DAT SDK dependency
4. Configure location and microphone permissions in `Info.plist`
5. Run on device (glasses pairing requires physical hardware)

## Documentation

See [docs/SCOPE.md](docs/SCOPE.md) for the complete scope document including user stories, data models, voice phrases, and phased roadmap.

## License

Proprietary — Meta / Aldo Omnia
