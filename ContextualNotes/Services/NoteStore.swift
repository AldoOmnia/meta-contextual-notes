import Foundation

/// Protocol for note persistence — implemented with SwiftData or Core Data
protocol NoteStoreProtocol {
    func save(_ note: Note) async throws
    func fetchRecent(limit: Int) async throws -> [Note]
    func fetchByPlace(placeName: String) async throws -> [Note]
    func fetchWithLocationTriggersNear(latitude: Double, longitude: Double) async throws -> [Note]
    func fetchWithDueTimeTriggers() async throws -> [Note]
    func delete(_ note: Note) async throws
}

/// In-memory store for MVP — replace with SwiftData/Core Data
@Observable
final class InMemoryNoteStore: NoteStoreProtocol {
    private var notes: [Note] = []
    private let queue = DispatchQueue(label: "com.contextualnotes.store")

    func save(_ note: Note) async throws {
        queue.sync {
            if let idx = notes.firstIndex(where: { $0.id == note.id }) {
                notes[idx] = note
            } else {
                notes.append(note)
            }
        }
    }

    func fetchRecent(limit: Int) async throws -> [Note] {
        queue.sync {
            Array(notes.sorted { $0.createdAt > $1.createdAt }.prefix(limit))
        }
    }

    func fetchByPlace(placeName: String) async throws -> [Note] {
        queue.sync {
            notes.filter {
                $0.placeName?.localizedCaseInsensitiveContains(placeName) == true
            }
        }
    }

    func fetchWithLocationTriggersNear(latitude: Double, longitude: Double) async throws -> [Note] {
        let threshold = 50.0 // meters
        return queue.sync {
            notes.filter { note in
                guard let trigger = note.trigger,
                      trigger.type == .location,
                      !trigger.fired,
                      let tLat = trigger.latitude,
                      let tLon = trigger.longitude
                else { return false }
                let dist = sqrt(pow(latitude - tLat, 2) + pow(longitude - tLon, 2)) * 111_000 // rough meters
                return dist <= (trigger.radius + threshold)
            }
        }
    }

    func fetchWithDueTimeTriggers() async throws -> [Note] {
        let now = Date()
        return queue.sync {
            notes.filter { note in
                guard let trigger = note.trigger,
                      trigger.type == .time,
                      !trigger.fired,
                      let fireAt = trigger.fireAt
                else { return false }
                return fireAt <= now
            }
        }
    }

    func delete(_ note: Note) async throws {
        queue.sync {
            notes.removeAll { $0.id == note.id }
        }
    }
}
