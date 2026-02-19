//
// PairingInstructionsView.swift
// Contextual Notes
//
// Meta DAT pairing instructions — aligned with CTA Transit Assistant.
// Refs: wearables.developer.meta.com, github.com/facebook/meta-wearables-dat-ios
//

import SwiftUI

private let metaAIAppStoreURL = "https://apps.apple.com/app/meta-ai/id1558240027"
private let metaAIScheme = "metaai://"

struct PairingInstructionsView: View {
    var onStartPairing: (() -> Void)?
    var onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Before you pair, follow these steps:")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    instructionRow(
                        number: 1,
                        title: "Enable Developer Mode",
                        detail: "Open the Meta AI app. Go to Settings → Developer Mode and turn it ON."
                    )
                    Button(action: openMetaAIApp) {
                        Label("Open Meta AI App", systemImage: "arrow.up.forward.square")
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.accent)
                    }

                    instructionRow(
                        number: 2,
                        title: "Charge your glasses",
                        detail: "Ensure your Ray-Ban Meta or Oakley Meta glasses are charged."
                    )

                    instructionRow(
                        number: 3,
                        title: "Turn on Bluetooth",
                        detail: "Go to iPhone Settings → Bluetooth and turn it ON. Keep your phone and glasses close together."
                    )

                    instructionRow(
                        number: 4,
                        title: "Wear your glasses",
                        detail: "Put on your glasses. The app will discover and connect when you tap Pair below."
                    )

                    VStack(spacing: 12) {
                        Text("Supported devices: Ray-Ban Meta, Oakley Meta HSTN")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Link("Meta Wearables Developer Docs", destination: URL(string: "https://wearables.developer.meta.com/docs/develop/")!)
                            .font(.caption)
                    }
                    .padding(.top, 8)
                }
                .padding(24)
            }
            .navigationTitle("How to Pair")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onDismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    if let start = onStartPairing {
                        Button(action: start) {
                            Label("Connect to Glasses", systemImage: "link")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(AppTheme.accent)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            }
        }
    }

    private func openMetaAIApp() {
        if let metaURL = URL(string: metaAIScheme),
           UIApplication.shared.canOpenURL(metaURL) {
            UIApplication.shared.open(metaURL)
        } else if let storeURL = URL(string: metaAIAppStoreURL) {
            UIApplication.shared.open(storeURL)
        }
    }

    private func instructionRow(number: Int, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Text("\(number)")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(AppTheme.accent)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline.bold())
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
