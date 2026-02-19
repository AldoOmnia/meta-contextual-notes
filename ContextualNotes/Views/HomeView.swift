import SwiftUI

enum RecordingStatus {
    case none
    case recording
    case finished
}

/// Home — pairing status at top, record meeting, recording status, quick note
struct HomeView: View {
    let env: AppEnvironment

    @State private var showRecordSheet = false
    @State private var recordings: [MeetingRecording] = []
    @State private var recordingStatus: RecordingStatus = .none

    var body: some View {
        NavigationStack {
            List {
                // Glasses status card — first
                Section {
                    GlassesStatusCard(isConnected: env.metaDATService.isConnected)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))

                // Record meeting — single indicator when recording, accent styling
                Section {
                    if recordingStatus == .recording && env.recordingService.isRecording {
                        // Recording: same slot, controls inline
                        HStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(.red.opacity(0.2))
                                    .frame(width: 56, height: 56)
                                Image(systemName: "record.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(.red)
                            }
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Recording...")
                                    .font(.title3.weight(.semibold))
                                    .foregroundStyle(.primary)
                                HStack(spacing: 12) {
                                    Button("Stop & Save") {
                                        _ = env.recordingService.stopRecording()
                                        recordings = env.recordingService.listRecordings()
                                        recordingStatus = .finished
                                        Task {
                                            try? await Task.sleep(nanoseconds: 2_000_000_000)
                                            recordingStatus = .none
                                        }
                                    }
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.green)
                                    Button("Cancel") {
                                        env.recordingService.cancelRecording()
                                        recordingStatus = .none
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                }
                            }
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 4)
                    } else if recordingStatus == .finished {
                        // Brief "saved" state
                        HStack(spacing: 16) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 28))
                                .foregroundStyle(.green)
                            Text("Recording saved")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(.green)
                            Spacer()
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 4)
                    } else {
                        // Default: Record meeting button — red, elegant shadow
                        Button {
                            showRecordSheet = true
                        } label: {
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(.red.opacity(0.15))
                                        .frame(width: 56, height: 56)
                                    Image(systemName: "record.circle.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(.red)
                                }
                                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Record meeting")
                                        .font(.title3.weight(.semibold))
                                        .foregroundStyle(.primary)
                                    Text("Capture speakers and conversation with your glasses")
                                        .font(.subheadline)
                                        .foregroundStyle(AppTheme.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 4)
                        }
                        .buttonStyle(.plain)
                        .disabled(env.recordingService.isRecording)
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                )
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))

                // Recent recordings
                Section("Recent recordings") {
                    if recordings.isEmpty {
                        Text("No recordings yet")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(recordings) { rec in
                            NavigationLink {
                                RecordingDetailView(recording: rec, env: env)
                            } label: {
                                RecordingRow(recording: rec)
                            }
                        }
                    }
                }

                // Quick note — voice as primary input
                Section("Quick note") {
                    QuickNoteVoiceView(env: env) {
                        env.notesVersion += 1
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Contextual Notes")
                        .font(.headline)
                }
            }
            .task { recordings = env.recordingService.listRecordings() }
            .refreshable { recordings = env.recordingService.listRecordings() }
            .sheet(isPresented: $showRecordSheet) {
                RecordMeetingSheet(
                    env: env,
                    onStart: {
                        showRecordSheet = false
                        recordingStatus = .recording
                        recordings = env.recordingService.listRecordings()
                    },
                    onDismiss: { showRecordSheet = false }
                )
            }
        }
    }
}

/// Glasses status card — sleek design with glasses image (media.webp style)
struct GlassesStatusCard: View {
    let isConnected: Bool

    var body: some View {
        HStack(spacing: 16) {
            // Glasses image (no_background.png)
            Image("Glasses")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 48)

            VStack(alignment: .leading, spacing: 4) {
                Text(isConnected ? "Connected" : "Not paired")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(isConnected ? "Ready to record" : "Pair glasses to record meetings")
                    .font(.caption)
                    .foregroundStyle(AppTheme.textSecondary)
            }

            Spacer()

            HStack(spacing: 6) {
                Circle()
                    .fill(isConnected ? Color.green : Color.gray.opacity(0.5))
                    .frame(width: 8, height: 8)
                Text(isConnected ? "Live" : "Off")
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(isConnected ? .green : AppTheme.textSecondary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.separator).opacity(0.5), lineWidth: 0.5)
                )
        )
    }
}

struct RecordingRow: View {
    let recording: MeetingRecording

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VideoThumbnailView(videoURL: recording.videoURL, hasVideo: recording.hasVideo)
                .frame(width: 80, height: 45)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(recording.title)
                        .font(AppTheme.headline())
                    if recording.hasVideo {
                        Image(systemName: "video.fill")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                Text(recording.createdAt.formatted())
                    .font(AppTheme.caption())
                    .foregroundStyle(AppTheme.textSecondary)
                if let ctx = recording.context, let place = ctx.placeName ?? ctx.placeType {
                    Text(place)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
