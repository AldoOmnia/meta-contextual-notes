import Foundation

/// A meeting recording with optional video, transcript, and context
struct MeetingRecording: Identifiable, Codable, Sendable {
    let id: UUID
    var title: String
    var createdAt: Date
    var duration: TimeInterval
    var videoURL: String?
    var thumbnailURL: String?   // Video thumbnail for list view
    var audioURL: String?
    var transcript: [TranscriptSegment]
    var hasVideo: Bool
    var context: RecordingContext?
}

extension MeetingRecording {
    /// Full transcript as plain text (optionally with speaker labels)
    var transcriptText: String {
        transcript.map { seg in
            if let label = seg.speakerLabel {
                return "\(label): \(seg.text)"
            } else {
                return seg.text
            }
        }.joined(separator: "\n\n")
    }
}
