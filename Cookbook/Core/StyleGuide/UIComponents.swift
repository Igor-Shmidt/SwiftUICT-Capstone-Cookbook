//
//  UIComponents.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//


import SwiftUI

/// A standard card container for our Cookbook items.
struct CookbookCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(Color.Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Interactive Components

/// A button style that adds a smooth scaling animation when pressed.
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // Scale down to 95% when pressed
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            // Add a modern spring animation
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            // Slightly reduce opacity for visual feedback
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

/// A component for displaying categories (e.g., "Pizza", "Produce") as a tag.
/// - Parameters:
///   - text: The category text.
///   - color: The base color of the tag.
@ViewBuilder
func CategoryTag(text: String, color: Color = Color.Theme.primary) -> some View {
    Text(text)
        .font(.caption)
        .fontWeight(.bold)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        // Make the background semi-transparent based on the main color
        .background(color.opacity(0.15))
        // Tint the text with the main color for contrast
        .foregroundStyle(color)
        .clipShape(Capsule())
}

/// A beautiful placeholder for empty lists.
/// - Parameters:
///   - icon: The SF Symbols icon name.
///   - message: The message to display to the user.
@ViewBuilder
func EmptyStateView(icon: String, message: String) -> some View {
    VStack(spacing: 16) {
        Image(systemName: icon)
            .font(.system(size: 56))
            .foregroundStyle(Color.Theme.secondaryText.opacity(0.7))
            // Modern SF Symbols animation (pulse)
            .symbolEffect(.pulse, options: .repeating)

        Text(message)
            .font(.headline)
            .foregroundStyle(Color.Theme.secondaryText)
            .multilineTextAlignment(.center)
    }
    .padding()
}

// MARK: - View Extensions

extension View {
    /// Applies the standard large button design used throughout the app.
    func primaryButton() -> some View {
        self
            .font(.headline)
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.Theme.primary)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
