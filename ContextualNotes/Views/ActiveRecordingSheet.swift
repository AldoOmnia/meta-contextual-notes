import SwiftUI

/// Full-screen sheet during recording — Stop & Save, Cancel (discard)
struct ActiveRecordingSheet: View {
    let env: AppEnvironment
    let onSaved: () -> Void
    let onDismiss: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "record.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.red)
                .symbolEffect(.pulse, options: .repeating)

            VStack(spacing: 8) {
                Text("Recording")
                    .font(AppTheme.titleLarge())
                Text("Tap Stop to save, Cancel to discard")
                    .font(AppTheme.caption())
                    .foregroundStyle(AppTheme.textSecondary)
            }

            Spacer()

            VStack(spacing: 16) {
                Button {
                    if let _ = env.recordingService.stopRecording() {
                        onSaved()
                    }
                    dismiss()
                } label: {
                    Label("Stop & Save", systemImage: "stop.circle.fill")
                        .font(AppTheme.headline())
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

                Button {
                    env.recordingService.cancelRecording()
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(AppTheme.headline())
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 48)
        }
        .interactiveDismissDisabled()
    }
}
