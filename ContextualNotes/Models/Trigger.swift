import Foundation

/// Contextual trigger for surfacing a note (location geofence or time)
struct Trigger: Codable, Sendable {
    var type: TriggerType
    var latitude: Double?
    var longitude: Double?
    var placeName: String?
    var radius: Double  // meters
    var fireAt: Date?
    var fired: Bool
}

extension Trigger {
    init(type: TriggerType = .none) {
        self.type = type
        self.latitude = nil
        self.longitude = nil
        self.placeName = nil
        self.radius = 50
        self.fireAt = nil
        self.fired = false
    }
}
