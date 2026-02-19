import Foundation

/// Type of note capture (voice memo vs quick text)
enum NoteType: String, Codable, Sendable {
    case voiceMemo
    case text
}
