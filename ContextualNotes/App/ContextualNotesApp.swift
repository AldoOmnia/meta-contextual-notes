import SwiftUI

@main
struct ContextualNotesApp: App {
    @State private var env = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            ContentView(env: env)
        }
    }
}
