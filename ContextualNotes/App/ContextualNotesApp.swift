import SwiftUI

@main
struct ContextualNotesApp: App {
    @State private var env = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            ContentView(env: env)
                .onOpenURL { url in
                    Task {
                        await env.metaDATService.handleURL(url)
                    }
                }
        }
    }
}
