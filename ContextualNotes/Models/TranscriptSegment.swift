import Foundation

/// A segment of transcript with optional speaker identification
struct TranscriptSegment: Codable, Sendable, Identifiable {
    let id: UUID
    var speakerLabel: String?  // "Speaker 1", "You", or nil if unknown
    var text: String
    var startTime: TimeInterval?
    var endTime: TimeInterval?
}
