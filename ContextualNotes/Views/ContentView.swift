import SwiftUI

/// Root navigation: Pairing → Onboarding → Main app (Record meeting primary)
struct ContentView: View {
    let env: AppEnvironment

    var body: some View {
        Group {
            if !env.metaDATService.isPaired {
                PairingView(metaDATService: env.metaDATService)
            } else if !env.hasSeenPostPairingIntro {
                PostPairingIntroView(env: env) {
                    env.hasSeenPostPairingIntro = true
                }
            } else if !env.hasCompletedOnboarding {
                OnboardingView(env: env, onComplete: {
                    env.hasCompletedOnboarding = true
                })
            } else {
                TabView {
                    HomeView(env: env)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    RecordingsListView(env: env)
                        .tabItem {
                            Label("Recordings", systemImage: "waveform")
                        }
                    NotesListView(env: env)
                        .tabItem {
                            Label("Notes", systemImage: "note.text")
                        }
                    SettingsView(env: env)
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                }
            }
        }
        .environment(env)
    }
}
