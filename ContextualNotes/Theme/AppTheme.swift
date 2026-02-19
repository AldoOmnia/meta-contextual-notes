//
// AppTheme.swift
// Contextual Notes
//
// White, minimal theme — notes apps are simple and clean.
//

import SwiftUI

enum AppTheme {
    // Backgrounds — white and light grays
    static let background = Color(white: 0.98)
    static let cardBackground = Color.white
    static let cardBackgroundElevated = Color.white

    // Text
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let textTertiary = Color(white: 0.5)

    // Accent
    static let accent = Color(red: 8/255, green: 102/255, blue: 255/255)
    static let accentBackground = Color(red: 8/255, green: 102/255, blue: 255/255).opacity(0.12)
    static let success = Color(red: 52/255, green: 199/255, blue: 89/255)

    // Typography
    static func title() -> Font { .title2.weight(.bold) }
    static func titleLarge() -> Font { .largeTitle.weight(.bold) }
    static func headline() -> Font { .headline }
    static func body() -> Font { .body }
    static func callout() -> Font { .callout }
    static func caption() -> Font { .subheadline }
}
