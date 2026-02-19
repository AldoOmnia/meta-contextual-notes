import SwiftUI

/// Pair Meta AI Glasses (Ray-Ban Meta) via Meta DAT
/// Layout and branding aligned with CTA Transit Assistant & Meta Browser Commerce
struct PairingView: View {
    let metaDATService: MetaDATService

    @State private var isPairing = false
    @State private var showPairingInstructions = false

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Person in meeting with Meta AI glasses — preserve aspect ratio, no squashing
                Image("MeetingHero")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: min(UIScreen.main.bounds.width - 48, 320))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)

                VStack(spacing: 16) {
                    Text("Connect Meta AI Glasses")
                        .font(AppTheme.title())
                        .foregroundStyle(AppTheme.textPrimary)

                    Text("Pair with Ray-Ban Meta glasses to record meetings and capture notes by voice.")
                        .font(AppTheme.callout())
                        .foregroundStyle(AppTheme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                HStack(spacing: 8) {
                    Circle()
                        .fill(AppTheme.accent)
                        .frame(width: 14, height: 14)
                        .opacity(isPairing ? 0.6 : 1)
                        .scaleEffect(isPairing ? 1.2 : 1)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isPairing)
                    Text(isPairing ? "Searching for glasses..." : "Ready to connect")
                        .font(AppTheme.callout())
                        .foregroundStyle(AppTheme.textSecondary)
                }

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        Task {
                            isPairing = true
                            await metaDATService.startPairing()
                            isPairing = false
                        }
                    } label: {
                        if isPairing {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Pair Glasses")
                                .font(AppTheme.headline())
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical, 18)
                    .background(AppTheme.accent)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(isPairing)

                    Button {
                        showPairingInstructions = true
                    } label: {
                        Text("How to pair")
                            .font(AppTheme.callout())
                            .fontWeight(.medium)
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

                // Powered by Omnia
                VStack(spacing: 6) {
                    Text("Powered by")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.textTertiary)
                    Image("OmniaLogo")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(AppTheme.textSecondary)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 18)
                }
                .padding(.bottom, 24)
            }
        }
        .sheet(isPresented: $showPairingInstructions) {
            PairingInstructionsView(
                onStartPairing: {
                    showPairingInstructions = false
                    Task {
                        isPairing = true
                        await metaDATService.startPairing()
                        isPairing = false
                    }
                },
                onDismiss: { showPairingInstructions = false }
            )
        }
    }

}
