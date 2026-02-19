# Meta Contextual Notes App — Scope Document

## 1. Overview

### Purpose

Contextual Notes is a Meta AI Glasses app with a **hybrid model**:
- **Primary:** Meeting recorder — capture multi-speaker conversations with optional video and transcript
- **Secondary:** Contextual notes — quick memos with location/time triggers

### Target Device

- Meta AI Glasses (Ray-Ban Meta)
- iOS companion app (Swift, SwiftUI, Meta DAT SDK)

### Primary CTA

**Record meeting** — users record meetings (with or without video), get transcript with speaker identification, and can export both recording and transcript.

### Secondary: Contextual Notes

Notes are tied to context (place, time, conversation) so reminders and recall are situation-aware.

## 2. User Stories

| ID | As a... | I want to... | So that... |
|----|---------|--------------|-------------|
| US-1 | Commuter | Say "Remember this for when I get to the station" | The note resurfaces when I arrive at my usual station |
| US-2 | Shopper | Say "Remember to compare this with the Nike ones when I'm home" | I get a reminder at home to compare products |
| US-3 | Professional | Dictate a quick idea while walking | It's captured with location and time for later review |
| US-4 | User with accessibility needs | Create notes hands-free by voice | I don't need to use a phone or keyboard |
| US-5 | Parent | Say "Remind me when I pick up the kids" | I get an audio reminder at pickup time/location |
| US-6 | Explorer | Capture a thought with "note this" | It's stored with where I was and when |
| US-7 | User | Ask "What did I note at the coffee shop?" | Past notes filtered by place appear |
| US-8 | User | Hear recent notes when near a relevant location | Context surfaces without asking |

## 3. Features

### 3.1 Core (MVP)

| Feature | Description | Priority |
|---------|-------------|----------|
| Voice capture | Capture notes via Meta DAT mic | P0 |
| Timestamp | Store capture time | P0 |
| Location | Store capture location (Core Location) | P0 |
| Audio playback | TTS playback of notes on glasses | P0 |
| List recent | "What are my recent notes?" returns last N notes | P0 |
| Save to device | Persist notes locally (Core Data / SwiftData) | P0 |
| Note types | Voice memo vs. quick text note | P0 |

### 3.2 Contextual Triggers (MVP+)

| Feature | Description | Priority |
|---------|-------------|----------|
| Location trigger | "Remind me when I get to [place]" | P1 |
| Time trigger | "Remind me at [time]" | P1 |
| Geofence-based recall | Surface notes when user enters saved geofence | P1 |
| Context labels | Tag notes by place type (station, shop, home, etc.) | P1 |

### 3.3 Enhancement (Post-MVP)

| Feature | Description | Priority |
|---------|-------------|----------|
| "At station" shortcut | Integrate CTA station context for transit notes | P2 |
| Commerce link | "Remember this product" → link to Browser Commerce | P2 |
| Search by context | "Notes from last week at home" | P2 |
| Edit/delete | Edit or delete notes by voice | P2 |
| Export | Export notes (text, audio) | P2 |
| Sharing | Share note to Messages/email | P3 |

## 4. Technical Scope

### 4.1 Platform & Stack

| Component | Technology |
|-----------|------------|
| Platform | iOS 15.2+ |
| Language | Swift 6 |
| UI | SwiftUI |
| Glasses | Meta Wearables DAT SDK |
| Persistence | SwiftData or Core Data |
| Location | Core Location |
| Audio | AVFoundation (playback), Meta DAT (glasses playback) |

### 4.2 Data Model

```
Note
├── id: UUID
├── content: String (transcript of voice or text)
├── audioURL: String? (optional raw audio file path)
├── createdAt: Date
├── location: CLLocationCoordinate2D?
├── placeName: String? (reverse-geocoded)
├── trigger: Trigger?
└── tags: [String]?

Trigger
├── type: enum (none | location | time)
├── location: CLLocationCoordinate2D? (for geofence)
├── placeName: String?
├── radius: Double (meters)
├── fireAt: Date? (for time trigger)
└── fired: Bool
```

### 4.3 Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  Meta AI Glasses                                             │
│  - Voice input (Meta DAT mic)                                │
│  - TTS output (Meta DAT speaker)                              │
└─────────────────────────────────────────────────────────────┘
                              ↕ Meta DAT SDK
┌─────────────────────────────────────────────────────────────┐
│  Contextual Notes App (iOS)                                   │
│  ├── NoteCaptureService   - record, transcribe, save         │
│  ├── NoteRecallService    - query by context, trigger check   │
│  ├── LocationService      - Core Location, geofencing        │
│  ├── MetaDATService       - pairing, audio in/out            │
│  └── TriggerMonitor       - time + location triggers         │
└─────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────┐
│  Local Storage (SwiftData / Core Data)                       │
│  - Notes                                                    │
│  - Triggers                                                 │
└─────────────────────────────────────────────────────────────┘
```

### 4.4 Voice Phrases

| Intent | Example phrase | Action |
|--------|----------------|--------|
| Quick note | "Note this", "Remember", "Memo" | Capture and save with time + location |
| Note with trigger | "Remind me when I get to [place]" | Save + location trigger |
| Time reminder | "Remind me at 3pm" | Save + time trigger |
| Recall recent | "What are my recent notes?" | List recent N |
| Recall by place | "Notes from the station" | Filter by place |
| Play note | "Play my last note" | TTS on glasses |
| Delete | "Delete that note" | Remove last/referenced note |

## 5. Screens & UX

### 5.1 App Screens

| Screen | Purpose |
|--------|---------|
| PairingView | Pair Meta glasses via Meta DAT |
| HomeView | Quick capture, recent notes, connection status |
| NotesListView | All notes, filters (place, date, type) |
| NoteDetailView | View/edit note, triggers, location on map |
| SettingsView | Permissions (location, mic), defaults |

### 5.2 Glasses Interactions

| Interaction | On glasses |
|-------------|------------|
| Capture | Voice in → confirmation ("Note saved") |
| Recall | Voice query → TTS response with note(s) |
| Trigger fire | TTS reminder when condition met |
| Status | Short status ("3 notes today") |

## 6. Out of Scope (MVP)

| Item | Reason |
|------|--------|
| Cloud sync | MVP is local-only |
| Collaboration | Single-user only |
| Transcription service | Can use device-side or simple pass-through |
| Vision capture | Text/audio only |
| Cross-device sync | Future iteration |
| Third-party integrations | Future (CTA, Commerce) |

## 7. Dependencies

| Dependency | Notes |
|------------|-------|
| Meta Wearables DAT | Pairing, mic, speaker |
| CTA app | Optional integration (station context) |
| Browser Commerce | Optional "remember product" |
| Core Location | Always-on when app is active |
| Speech-to-text | Device or cloud for transcription |

## 8. Success Criteria

| Metric | Target |
|--------|--------|
| Capture latency | < 2 sec from phrase to saved |
| Trigger accuracy | Geofence within ~50 m; time within 1 min |
| Battery | < 5% extra drain from location/triggers |
| Accessibility | All flows usable by voice only |
| TestFlight | Usable build for internal testing |

## 9. Phases

**Phase 1 — Core (2–3 weeks)**
- Meta DAT pairing
- Voice capture + save with time + location
- List recent notes
- TTS playback on glasses
- Basic SwiftUI UI

**Phase 2 — Triggers (1–2 weeks)**
- Location triggers ("remind at [place]")
- Time triggers ("remind at [time]")
- Trigger monitor (background location or foreground-only)

**Phase 3 — Polish (1 week)**
- Refine voice phrases
- UI polish
- TestFlight release

## 10. Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Background location limits | Use significant location change; clarify with users |
| Transcription quality | Start with raw audio; add transcription later |
| Meta DAT availability | Fallback to app-only capture |
| Battery impact | Tune location and wake frequency |

## 11. Alignment with Skills Hub

Contextual Notes supports the Omnia Skills Hub by:
- Providing shared context for CTA and Commerce
- Demonstrating a third skill (Transit, Commerce, Notes)
- Being the "context layer" that improves personalization
- Showing acquisition value: context + vertical skills
