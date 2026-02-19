import SwiftUI

/// Full list of meeting recordings
struct RecordingsListView: View {
    let env: AppEnvironment

    @State private var recordings: [MeetingRecording] = []

    var body: some View {
        NavigationStack {
            List {
                if recordings.isEmpty {
                    ContentUnavailableView(
                        "No recordings",
                        systemImage: "waveform",
                        description: Text("Tap Record meeting on Home to capture your first meeting.")
                    )
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
            .navigationTitle("Recordings")
            .task { recordings = env.recordingService.listRecordings() }
            .refreshable { recordings = env.recordingService.listRecordings() }
        }
    }
}
