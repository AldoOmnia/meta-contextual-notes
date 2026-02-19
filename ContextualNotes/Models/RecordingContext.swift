import Foundation

/// Environment and location context for recall-when-context-matches
struct RecordingContext: Codable, Sendable {
    var placeName: String?
    var placeType: String?       // "office", "home", "café", "conference room", etc.
    var latitude: Double?
    var longitude: Double?
    var sceneLabels: [String]?  // On-device AI: "indoor", "meeting room", etc.
    var radiusMeters: Double
}

extension RecordingContext {
    init() {
        self.placeName = nil
        self.placeType = nil
        self.latitude = nil
        self.longitude = nil
        self.sceneLabels = nil
        self.radiusMeters = 50
    }
}
