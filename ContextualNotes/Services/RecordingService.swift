import Foundation
import AVFoundation

/// Manages meeting recordings — capture via device mic (or Meta DAT when wired), storage, export.
/// Ready for glasses testing: audio capture works; wire Meta DAT mic/camera when SDK integrated.
@Observable
final class RecordingService {
    private var recordings: [MeetingRecording] = []
    private let queue = DispatchQueue(label: "com.contextualnotes.recordings")

    var isRecording = false
    var currentRecordingHasVideo = false

    private var audioRecorder: AVAudioRecorder?
    private var currentRecordingURL: URL?
    private var recordingStartTime: Date?
    private var locationService: LocationServiceProtocol?
    private let metaDATService: MetaDATServiceProtocol?

    /// User preference from onboarding (default for new recordings)
    var recordVideoByDefault: Bool {
        get { UserDefaults.standard.bool(forKey: "recordVideoByDefault") }
        set { UserDefaults.standard.set(newValue, forKey: "recordVideoByDefault") }
    }

    init(
        locationService: LocationServiceProtocol? = nil,
        metaDATService: MetaDATServiceProtocol? = nil
    ) {
        self.locationService = locationService
        self.metaDATService = metaDATService
    }

    /// Recording output directory (Documents/Recordings)
    private static var recordingsDirectory: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Recordings", isDirectory: true)
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    func startRecording(withVideo: Bool) {
        isRecording = true
        currentRecordingHasVideo = withVideo
        recordingStartTime = Date()

        // Prefer Meta DAT mic when connected; fallback to device mic
        if metaDATService?.isConnected == true {
            // TODO: Meta DAT — wire metaDATService.startListening() and stream to file
            // For now: use device mic
        }

        startAudioRecorder()
        // TODO: If withVideo && metaDAT connected: start MWDATCamera stream, save to videoURL
    }

    private func startAudioRecorder() {
        let id = UUID().uuidString
        let url = Self.recordingsDirectory.appendingPathComponent("\(id).m4a")
        currentRecordingURL = url

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            let recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder.record()
            audioRecorder = recorder
        } catch {
            print("[RecordingService] Failed to start audio: \(error)")
        }
    }

    func cancelRecording() {
        isRecording = false
        audioRecorder?.stop()
        audioRecorder = nil
        if let url = currentRecordingURL {
            try? FileManager.default.removeItem(at: url)
        }
        currentRecordingURL = nil
    }

    func stopRecording() -> MeetingRecording? {
        guard isRecording else { return nil }
        isRecording = false

        let start = recordingStartTime ?? Date()
        let duration = Date().timeIntervalSince(start)

        audioRecorder?.stop()
        let audioURL = currentRecordingURL?.path
        audioRecorder = nil
        currentRecordingURL = nil

        // Capture context — use cached location when available
        var context = RecordingContext()
        if let loc = locationService?.currentLocation {
            context.latitude = loc.coordinate.latitude
            context.longitude = loc.coordinate.longitude
            // placeName from reverse geocode can be filled async later if needed
        }

        let recording = MeetingRecording(
            id: UUID(),
            title: "Meeting \(start.formatted(date: .abbreviated, time: .shortened))",
            createdAt: start,
            duration: duration,
            videoURL: currentRecordingHasVideo ? nil : nil,  // TODO: MWDATCamera → save to file
            thumbnailURL: nil,
            audioURL: audioURL,
            transcript: [
                TranscriptSegment(
                    id: UUID(),
                    speakerLabel: nil,
                    text: "[Recording ready. Transcription coming when speech API wired.]",
                    startTime: 0,
                    endTime: max(0.1, duration)
                )
            ],
            hasVideo: currentRecordingHasVideo,
            context: context
        )

        queue.sync { recordings.insert(recording, at: 0) }
        return recording
    }

    func listRecordings() -> [MeetingRecording] {
        queue.sync { recordings }
    }

    func exportTranscript(_ recording: MeetingRecording) -> String {
        recording.transcriptText
    }

    func exportRecordingURL(_ recording: MeetingRecording) -> URL? {
        guard let path = recording.audioURL else { return nil }
        let url = URL(fileURLWithPath: path)
        return FileManager.default.fileExists(atPath: path) ? url : nil
    }
}
