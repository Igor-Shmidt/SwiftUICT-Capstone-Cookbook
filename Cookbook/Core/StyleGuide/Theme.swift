//
//  Theme.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//


import SwiftUI

/// Semantic color palette for the Cookbook app.
/// Utilizing system colors ensures automatic support for Light and Dark modes.
extension Color {
    enum Theme {
        /// The main brand color
        static let primary = Color.orange
        /// The background color for the main views
        static let background = Color(UIColor.systemGroupedBackground)
        /// The background color for cards and elevated surfaces
        static let surface = Color(UIColor.secondarySystemGroupedBackground)
        /// Primary text color
        static let text = Color.primary
        /// Secondary text color for subtitles or hints
        static let secondaryText = Color.secondary
    }
}

/// A pre-styled icon component supporting RTL layouts and colorful variants.
/// - Parameters:
///   - symbol: The SF Symbol name.
///   - color: The base color for the icon.
@ViewBuilder
func ThemedIcon(symbol: String, color: Color = Color.Theme.primary) -> some View {
    Image(systemName: symbol)
        .symbolVariant(.fill) // Uses the filled variant of the SF Symbol
        .foregroundStyle(color.gradient) // Modern Swift feature: instant gradients
        .imageScale(.large)
        // Automatically flips the icon horizontally for Right-to-Left (RTL) languages like Arabic or Hebrew
        .flipsForRightToLeftLayoutDirection(true)
}
