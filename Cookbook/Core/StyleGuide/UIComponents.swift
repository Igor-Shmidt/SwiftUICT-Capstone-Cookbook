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
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.Theme.background.gradient.opacity(0.6))
                    .blur(radius: 16)
            )
            .liquidGlass()
    }
}

@ViewBuilder
func AppIcon() -> some View {
    ThemedIcon(symbol: "fork.knife.circle.fill", color: Color.Theme.primary)
}

@ViewBuilder
func AppIconBig() -> some View {
    AppIcon()
        .font(.system(size: 90))
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
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .liquidGlass()
        .font(.caption)
        .fontWeight(.bold)
        // Tint the text with the main color for contrast
        .foregroundStyle(color)
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

struct SkyBackground: View {
    var body: some View {
        GeometryReader { geometry in
            let width = min(geometry.size.width, geometry.size.height)
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.07, blue: 0.15),
                        Color(red: 0.10, green: 0.14, blue: 0.26),
                        Color(red: 0.10, green: 0.10, blue: 0.20),
                        Color(red: 0.52, green: 0.24, blue: 0.20),
                        Color(red: 0.91, green: 0.48, blue: 0.25)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                RadialGradient(
                    colors: [
                        Color(red: 0.93, green: 0.96, blue: 1.0).opacity(0.85),
                        Color(red: 0.72, green: 0.78, blue: 0.95).opacity(0.24),
                        .clear
                    ],
                    center: UnitPoint.zero,
                    startRadius: width * 0.4,
                    endRadius: width * 0.8
                )

                Circle()
                    .fill(Color(red: 0.94, green: 0.96, blue: 1.0))
                    .frame(width: width * 0.5)
                    .shadow(color: Color.white.opacity(0.35), radius: 18)
                    .position(x: geometry.size.width * 0.04, y: geometry.size.height * 0.02)
                    .blur(radius: 1)

                LinearGradient(
                    colors: [
                        Color(red: 0.05, green: 0.07, blue: 0.15),
                        Color(red: 0.10, green: 0.14, blue: 0.26),
                        .clear
                    ],
                    startPoint: UnitPoint(x: 0.5, y: -0.05),
                    endPoint: UnitPoint(x: 0.5, y: 0.06)
                )

                RadialGradient(
                    colors: [
                        Color(red: 1.0, green: 0.73, blue: 0.34).opacity(0.9),
                        Color(red: 0.96, green: 0.33, blue: 0.23).opacity(0.5),
                        .clear
                    ],
                    center: UnitPoint(x: 0.5, y: 1.08),
                    startRadius: 0,
                    endRadius: geometry.size.width * 0.52
                )

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 1.0, green: 0.76, blue: 0.35),
                                Color(red: 0.97, green: 0.43, blue: 0.25)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: geometry.size.width * 0.5)
                    .position(x: geometry.size.width * 0.5, y: geometry.size.height * 1 + width * 0.35)
                    .blur(radius: 1)
            }
            .ignoresSafeArea()
        }
    }
}
