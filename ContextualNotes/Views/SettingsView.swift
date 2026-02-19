import SwiftUI

/// Permissions (location, mic), defaults
struct SettingsView: View {
    let env: AppEnvironment

    var body: some View {
        List {
            Section("Permissions") {
                HStack {
                    Label("Location", systemImage: "location")
                    Spacer()
                    Text(env.locationService.isAuthorized ? "Authorized" : "Not authorized")
                        .foregroundStyle(.secondary)
                }
                Button("Request location access") {
                    env.locationService.requestWhenInUseAuthorization()
                }
            }

            Section("Glasses") {
                HStack {
                    Label("Ray-Ban Meta", systemImage: "glasses")
                    Spacer()
                    Text(env.metaDATService.isPaired ? "Paired" : "Not paired")
                        .foregroundStyle(.secondary)
                }
            }

            Section("Recording defaults") {
                Toggle("Record video by default", isOn: Binding(
                    get: { env.recordingService.recordVideoByDefault },
                    set: { env.recordingService.recordVideoByDefault = $0 }
                ))
            }

            Section("Contextual recall") {
                Text("Recall notes and recordings when context matches (location, environment)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Toggle("Enable contextual recall", isOn: Binding(
                    get: { env.userPreferences.contextualRecallEnabled },
                    set: { env.userPreferences.contextualRecallEnabled = $0 }
                ))

                if env.userPreferences.contextualRecallEnabled {
                    Toggle("Use location", isOn: Binding(
                        get: { env.userPreferences.useLocationForContext },
                        set: { env.userPreferences.useLocationForContext = $0 }
                    ))
                    Toggle("Use environment (on-device AI)", isOn: Binding(
                        get: { env.userPreferences.useEnvironmentForContext },
                        set: { env.userPreferences.useEnvironmentForContext = $0 }
                    ))
                }
            }

            Section("About") {
                LabeledContent("Version", value: "1.0.0")
                VStack(spacing: 6) {
                    Text("Powered by")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Image("OmniaLogo")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(.secondary)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 18)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Settings")
    }
}
