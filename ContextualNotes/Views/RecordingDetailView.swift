import SwiftUI
import AVFoundation

/// Wrapper for share sheet content
private struct ShareItem: Identifiable {
    let id = UUID()
    var text: String
}

/// View recording, transcript, export options
struct RecordingDetailView: View {
    let recording: MeetingRecording
    let env: AppEnvironment

    @State private var shareItem: ShareItem?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false

    var body: some View {
        List {
            Section {
                if recording.hasVideo {
                    VideoThumbnailView(videoURL: recording.videoURL, hasVideo: true)
                        .frame(height: 180)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text(recording.title)
                        .font(AppTheme.title())
                    HStack {
                        Label(recording.createdAt.formatted(), systemImage: "calendar")
                            .font(AppTheme.caption())
                            .foregroundStyle(AppTheme.textSecondary)
                        if recording.hasVideo {
                            Label("Video", systemImage: "video.fill")
                                .font(AppTheme.caption())
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                    }
                }
            }

            if let ctx = recording.context, (ctx.placeName != nil || ctx.placeType != nil) {
                Section("Context") {
                    if let place = ctx.placeName {
                        LabeledContent("Place", value: place)
                    }
                    if let type = ctx.placeType {
                        LabeledContent("Environment", value: type)
                    }
                }
            }

            Section("Transcript") {
                ForEach(recording.transcript) { seg in
                    VStack(alignment: .leading, spacing: 4) {
                        if let label = seg.speakerLabel {
                            Text(label)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(AppTheme.accent)
                        }
                        Text(seg.text)
                            .font(AppTheme.body())
                    }
                    .padding(.vertical, 4)
                }
            }

            if recording.audioURL != nil {
                Section("Playback") {
                    Button {
                        togglePlayback()
                    } label: {
                        Label(isPlaying ? "Stop" : "Play recording", systemImage: isPlaying ? "stop.fill" : "play.fill")
                    }
                }
            }

            Section("Export") {
                Button {
                    let text = env.recordingService.exportTranscript(recording)
                    shareItem = ShareItem(text: text)
                } label: {
                    Label("Export transcript", systemImage: "square.and.arrow.up")
                }
            }
        }
        .navigationTitle("Recording")
        .sheet(item: $shareItem) { item in
            ShareSheet(activityItems: [item.text])
        }
        .onDisappear {
            audioPlayer?.stop()
        }
    }

    private func togglePlayback() {
        if isPlaying {
            audioPlayer?.stop()
            audioPlayer = nil
            isPlaying = false
            return
        }
        guard let path = recording.audioURL,
              FileManager.default.fileExists(atPath: path) else { return }
        let url = URL(fileURLWithPath: path)
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            audioPlayer = player
            player.play()
            isPlaying = true
            Task {
                try? await Task.sleep(nanoseconds: UInt64(player.duration + 0.1) * 1_000_000_000)
                await MainActor.run {
                    if audioPlayer?.url == url {
                        isPlaying = false
                        audioPlayer = nil
                    }
                }
            }
        } catch {
            // ignore
        }
    }
}

// Simple share sheet wrapper
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
