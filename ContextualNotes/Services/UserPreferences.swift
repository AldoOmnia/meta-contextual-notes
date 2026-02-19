import Foundation

/// User preferences for contextual recall and app behavior
@Observable
final class UserPreferences {
    private let defaults = UserDefaults.standard

    // Contextual recall — "recall when context matches"
    var contextualRecallEnabled: Bool {
        get { defaults.bool(forKey: "contextualRecallEnabled") }
        set { defaults.set(newValue, forKey: "contextualRecallEnabled") }
    }

    var useLocationForContext: Bool {
        get { defaults.object(forKey: "useLocationForContext") as? Bool ?? true }
        set { defaults.set(newValue, forKey: "useLocationForContext") }
    }

    var useEnvironmentForContext: Bool {
        get { defaults.object(forKey: "useEnvironmentForContext") as? Bool ?? true }
        set { defaults.set(newValue, forKey: "useEnvironmentForContext") }
    }

    var recallRadiusMeters: Double {
        get { defaults.object(forKey: "recallRadiusMeters") as? Double ?? 50 }
        set { defaults.set(newValue, forKey: "recallRadiusMeters") }
    }
}
