import Foundation
import Combine

/// Records, transcribes, and saves notes with time + location context
@Observable
final class NoteCaptureService {
    private let noteStore: NoteStoreProtocol
    private let locationService: LocationServiceProtocol
    private let metaDATService: MetaDATServiceProtocol?

    init(
        noteStore: NoteStoreProtocol,
        locationService: LocationServiceProtocol,
        metaDATService: MetaDATServiceProtocol? = nil
    ) {
        self.noteStore = noteStore
        self.locationService = locationService
        self.metaDATService = metaDATService
    }

    /// Capture and save a note (from voice transcript or text)
    func capture(content: String, type: NoteType = .text, trigger: Trigger? = nil) async throws -> Note {
        let location = await locationService.currentLocationAsync()
        let (lat, lon) = (location?.coordinate.latitude, location?.coordinate.longitude)
        let placeName = location != nil ? await locationService.reverseGeocode(latitude: lat!, longitude: lon!) : nil

        let note = Note(
            content: content,
            createdAt: Date(),
            latitude: lat,
            longitude: lon,
            placeName: placeName,
            noteType: type,
            trigger: trigger
        )

        try await noteStore.save(note)
        return note
    }
}
