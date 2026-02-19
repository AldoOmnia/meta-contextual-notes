import Foundation

/// Queries notes by context and checks trigger conditions
@Observable
final class NoteRecallService {
    private let noteStore: NoteStoreProtocol

    init(noteStore: NoteStoreProtocol) {
        self.noteStore = noteStore
    }

    /// Fetch last N notes
    func recentNotes(limit: Int = 10) async throws -> [Note] {
        try await noteStore.fetchRecent(limit: limit)
    }

    /// Fetch notes filtered by place name (e.g. "station", "coffee shop")
    func notes(byPlace placeName: String) async throws -> [Note] {
        try await noteStore.fetchByPlace(placeName: placeName)
    }

    /// Fetch notes with pending triggers at current location
    func notesWithLocationTriggers(at lat: Double, lon: Double) async throws -> [Note] {
        try await noteStore.fetchWithLocationTriggersNear(latitude: lat, longitude: lon)
    }

    /// Fetch notes with time triggers due now
    func notesWithDueTimeTriggers() async throws -> [Note] {
        try await noteStore.fetchWithDueTimeTriggers()
    }
}
