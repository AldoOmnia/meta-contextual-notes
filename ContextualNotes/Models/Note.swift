import Foundation

/// A contextual note with optional trigger
struct Note: Identifiable, Codable, Sendable {
    let id: UUID
    var content: String
    var audioURL: String?
    var createdAt: Date
    var latitude: Double?
    var longitude: Double?
    var placeName: String?
    var placeType: String?      // On-device: "office", "home", etc.
    var noteType: NoteType
    var trigger: Trigger?
    var tags: [String]?

    init(
        id: UUID = UUID(),
        content: String,
        audioURL: String? = nil,
        createdAt: Date = Date(),
        latitude: Double? = nil,
        longitude: Double? = nil,
        placeName: String? = nil,
        placeType: String? = nil,
        noteType: NoteType = .text,
        trigger: Trigger? = nil,
        tags: [String]? = nil
    ) {
        self.id = id
        self.content = content
        self.audioURL = audioURL
        self.createdAt = createdAt
        self.latitude = latitude
        self.longitude = longitude
        self.placeName = placeName
        self.placeType = placeType
        self.noteType = noteType
        self.trigger = trigger
        self.tags = tags
    }
}
