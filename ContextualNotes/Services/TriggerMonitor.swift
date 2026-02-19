import Foundation
import CoreLocation

/// Monitors time and location triggers, surfaces notes when conditions are met
@Observable
final class TriggerMonitor {
    private let noteStore: NoteStoreProtocol
    private let locationService: LocationServiceProtocol
    private let metaDATService: MetaDATServiceProtocol?
    private var timer: Timer?

    var onNoteSurfaced: ((Note) -> Void)?

    init(
        noteStore: NoteStoreProtocol,
        locationService: LocationServiceProtocol,
        metaDATService: MetaDATServiceProtocol? = nil
    ) {
        self.noteStore = noteStore
        self.locationService = locationService
        self.metaDATService = metaDATService
    }

    func start() {
        // TODO: Start location monitoring for geofences
        // TODO: Start timer for time-based triggers
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            Task { await self?.checkTriggers() }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func checkTriggers() async {
        // Check time triggers
        let dueNotes = (try? await noteStore.fetchWithDueTimeTriggers()) ?? []
        for note in dueNotes {
            await surfaceNote(note)
        }

        // Check location triggers (if we have location)
        if let loc = await locationService.currentLocationAsync() {
            let nearNotes = (try? await noteStore.fetchWithLocationTriggersNear(
                latitude: loc.coordinate.latitude,
                longitude: loc.coordinate.longitude
            )) ?? []
            for note in nearNotes {
                await surfaceNote(note)
            }
        }
    }

    private func surfaceNote(_ note: Note) async {
        onNoteSurfaced?(note)
        await metaDATService?.playTTS(note.content)
        // TODO: Mark trigger as fired in store
    }
}
