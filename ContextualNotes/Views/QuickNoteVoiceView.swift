import SwiftUI
import AVFoundation

/// Voice-first quick note — tap mic to record
struct QuickNoteVoiceView: View {
    let env: AppEnvironment
    let onSaved: () -> Void

    @State private var isRecording = false
    @State private var statusText = "Tap to speak"
    @State private var audioRecorder: AVAudioRecorder?
    @State private var recordingURL: URL?
    @State private var lastRecordedContent: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 20) {
                Button {
                    if isRecording {
                        stopRecording()
                    } else {
                        startRecording()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(isRecording ? Color.red.opacity(0.2) : AppTheme.accent.opacity(0.15))
                            .frame(width: 64, height: 64)
                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(isRecording ? .red : AppTheme.accent)
                    }
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 8) {
                    Text(statusText)
                        .font(AppTheme.callout())
                        .fontWeight(isRecording ? .semibold : .regular)
                        .foregroundStyle(isRecording ? .primary : AppTheme.textSecondary)

                    VoiceWaveView(isActive: isRecording)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 0)
            }

            if let content = lastRecordedContent, !content.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.callout)
                        .foregroundStyle(.green)
                    Text("Quick note recorded: \(content)")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(.top, 4)
            }
        }
        .padding()
    }

    private func startRecording() {
        isRecording = true
        statusText = "Recording — tap to stop"
        // TODO: Wire to Meta DAT mic when available
        // For now: placeholder — will create note on stop
        recordingURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID().uuidString).m4a")
    }

    private func stopRecording() {
        isRecording = false
        statusText = "Saved. Tap to speak again."
        Task {
            let content = await saveNoteFromRecording()
            await MainActor.run {
                lastRecordedContent = content
                onSaved()
            }
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            await MainActor.run {
                statusText = "Tap to speak"
                lastRecordedContent = nil
            }
        }
    }

    private func saveNoteFromRecording() async -> String? {
        // Placeholder: save note with transcript
        // TODO: Transcribe audio → use real transcription
        do {
            let note = try await env.noteCaptureService.capture(
                content: "Voice note recorded",  // Replace with transcription
                type: .voiceMemo
            )
            return note.content
        } catch {
            return nil
        }
    }
}
