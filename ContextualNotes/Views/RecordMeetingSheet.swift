import SwiftUI

/// Sheet to start a meeting recording — case-by-case video toggle
struct RecordMeetingSheet: View {
    let env: AppEnvironment
    let onStart: () -> Void
    let onDismiss: () -> Void

    @State private var recordWithVideo: Bool

    init(env: AppEnvironment, onStart: @escaping () -> Void, onDismiss: @escaping () -> Void) {
        self.env = env
        self.onStart = onStart
        self.onDismiss = onDismiss
        _recordWithVideo = State(initialValue: env.recordingService.recordVideoByDefault)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "record.circle")
                    .font(.system(size: 56))
                    .foregroundStyle(.red)

                Text("Record meeting")
                    .font(AppTheme.title())

                Text("Capture speakers and conversation. Video is optional.")
                    .font(AppTheme.callout())
                    .foregroundStyle(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)

                Toggle(isOn: $recordWithVideo) {
                    Text("Include video")
                        .font(AppTheme.headline())
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 32)
            .navigationTitle("New recording")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onDismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        env.recordingService.startRecording(withVideo: recordWithVideo)
                        onStart()
                        onDismiss()
                    }
                }
            }
        }
    }
}
