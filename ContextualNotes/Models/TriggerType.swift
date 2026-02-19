import Foundation

/// Type of contextual trigger for a note
enum TriggerType: String, Codable, Sendable {
    case none
    case location
    case time
}
