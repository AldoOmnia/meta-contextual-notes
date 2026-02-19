import Foundation
import SwiftUI

/// Shared app environment — services and state
@Observable
final class AppEnvironment {
    let noteStore: InMemoryNoteStore
    let locationService: LocationService
    let metaDATService: MetaDATService
    let noteCaptureService: NoteCaptureService
    let noteRecallService: NoteRecallService
    let triggerMonitor: TriggerMonitor
    let recordingService: RecordingService
    let userPreferences: UserPreferences

    /// Bump to refresh notes list (e.g. when quick note saved)
    var notesVersion: Int = 0

    init() {
        let store = InMemoryNoteStore()
        let location = LocationService()
        let meta = MetaDATService()

        self.noteStore = store
        self.locationService = location
        self.metaDATService = meta
        self.noteCaptureService = NoteCaptureService(
            noteStore: store,
            locationService: location,
            metaDATService: meta
        )
        self.noteRecallService = NoteRecallService(noteStore: store)
        self.triggerMonitor = TriggerMonitor(
            noteStore: store,
            locationService: location,
            metaDATService: meta
        )
        self.recordingService = RecordingService(
            locationService: location,
            metaDATService: meta
        )
        self.userPreferences = UserPreferences()
    }
}

// MARK: - Onboarding state
extension AppEnvironment {
    var hasSeenPostPairingIntro: Bool {
        get { UserDefaults.standard.bool(forKey: "hasSeenPostPairingIntro") }
        set { UserDefaults.standard.set(newValue, forKey: "hasSeenPostPairingIntro") }
    }

    var hasCompletedOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") }
        set { UserDefaults.standard.set(newValue, forKey: "hasCompletedOnboarding") }
    }
}
