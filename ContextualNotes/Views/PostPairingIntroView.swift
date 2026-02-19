import SwiftUI

/// Shown after pairing — recording icon + mic, what the app does
struct PostPairingIntroView: View {
    let env: AppEnvironment
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 20) {
                // Recording icon + mic — what the app will do
                ZStack {
                    Circle()
                        .fill(AppTheme.accent.opacity(0.12))
                        .frame(width: 140, height: 140)
                    VStack(spacing: 8) {
                        Image(systemName: "record.circle.fill")
                            .font(.system(size: 52))
                            .foregroundStyle(.red)
                        Image(systemName: "mic.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(AppTheme.accent)
                    }
                }
            }

            VStack(spacing: 12) {
                Text("Record meetings. Capture notes.")
                    .font(AppTheme.titleLarge())
                    .multilineTextAlignment(.center)

                Text("Use your glasses to record meetings with transcript and video. Tap the mic for quick voice notes. Notes recall when you're back in the same place.")
                    .font(AppTheme.body())
                    .foregroundStyle(AppTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Spacer()

            Button {
                onContinue()
            } label: {
                Text("Continue")
                    .font(AppTheme.headline())
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .tint(AppTheme.accent)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(AppTheme.background)
    }
}
