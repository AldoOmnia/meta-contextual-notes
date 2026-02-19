import SwiftUI

/// Onboarding — idea.png style: LIVE badge, waveform, mic + speech bubble, video preference
struct OnboardingView: View {
    let env: AppEnvironment
    let onComplete: () -> Void

    @State private var recordVideoByDefault = false

    var body: some View {
        ZStack {
            // Light grey background (idea.png style)
            Color(white: 0.94)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // LIVE badge — top, red (idea.png)
                HStack {
                    HStack(spacing: 8) {
                        Text("LIVE")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.white)
                        Image(systemName: "play.fill")
                            .font(.caption2)
                            .foregroundStyle(.white)
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .font(.caption2)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.91, green: 0.30, blue: 0.24))
                    )
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 48)

                Spacer()

                // Central audio waveform (idea.png — vertical bars)
                OnboardingWaveformView()
                    .frame(height: 80)

                Spacer()

                // Mic with speech bubble (idea.png — bottom right area)
                HStack {
                    Spacer()
                    ZStack(alignment: .topLeading) {
                        // Speech bubble with ellipsis
                        VStack(spacing: 4) {
                            Text("...")
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                        .frame(width: 44, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black)
                        )
                        .offset(x: 8, y: -4)

                        // Microphone
                        Image(systemName: "mic.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(.black)
                            .offset(x: 40, y: 12)
                    }
                    .padding(.trailing, 24)
                }
                .padding(.bottom, 24)

                // Video preference toggle
                VStack(alignment: .leading, spacing: 12) {
                    Toggle(isOn: $recordVideoByDefault) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Record video by default")
                                .font(.headline)
                                .foregroundStyle(.black)
                            Text("You can change this for each recording.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .tint(Color(red: 0.91, green: 0.30, blue: 0.24))
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                )
                .padding(.horizontal, 24)

                Button {
                    Task { @MainActor in
                        env.recordingService.recordVideoByDefault = recordVideoByDefault
                        onComplete()
                    }
                } label: {
                    Text("Continue")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.91, green: 0.30, blue: 0.24))
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
        }
    }
}

private struct OnboardingWaveformView: View {
    private let barHeights: [CGFloat] = [0.35, 0.55, 0.75, 0.95, 0.95, 0.75, 0.55, 0.35]

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(0..<8, id: \.self) { i in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.black)
                    .frame(width: 12, height: 60 * barHeights[i])
            }
        }
    }
}
