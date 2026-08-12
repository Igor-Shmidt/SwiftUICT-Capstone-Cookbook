//
//  ViewModifiers.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//


import SwiftUI

// MARK: - View Extension

extension View {
    /// Applies a liquid glass effect to the view.
    /// - Parameter cornerRadius: The radius for the rounded corners (default is 16).
    func liquidGlass(cornerRadius: CGFloat = 16) -> some View {
        modifier(LiquidGlassModifier(cornerRadius: cornerRadius))
    }

    /// Applies a dynamic breathe animation
    /// - Parameters:
    ///   - isAnimating: Boolean flag to trigger the animation.
    func animatedBreathe(_ isAnimating: Bool) -> some View {
        modifier(AnimatedBreatheModifier(isAnimating: isAnimating))
    }

    /// Applies a dynamic slide-in animation from the specified screen edge.
    /// - Parameters:
    ///   - isAnimating: Boolean flag to trigger the animation.
    ///   - edge: The side of the screen to slide from (.leading or .trailing preferred).
    func animatedSlideIn(isAnimating: Bool, from edge: Edge) -> some View {
        self.modifier(SlideInAnimationModifier(
            isAnimating: isAnimating, edge: edge
        ))
    }
}


// MARK: LiquidGlassModifier
/// A view modifier that applies a "Liquid Glass" (Glassmorphism) effect.
/// It uses materials, a subtle stroke, and a shadow to create depth.
private struct LiquidGlassModifier: ViewModifier {
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    // Blend mode helps the stroke look natural in both dark and light modes
                    .blendMode(.overlay) 
            )
            .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

// MARK: AnimatedBreatheModifier

private struct AnimatedBreatheModifier: ViewModifier {
    let isAnimating: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(isAnimating ? 1.15 : 0.85)
            .opacity(isAnimating ? 1.0 : 0.6)
            .animation(
                .easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                value: isAnimating
            )
    }
}

/// Modifier that animates a view sliding in dynamically from off-screen.
private struct SlideInAnimationModifier: ViewModifier {
    private enum Constants {
        static let scale: CGFloat = 4
        static let animationDuration: TimeInterval = 1.6
    }
    /// Controls the animation state
    let isAnimating: Bool

    /// The side of the screen from which the view will enter
    let edge: Edge
    var isHorizontal: Bool {
        Edge.Set.horizontal.contains(.init(edge))
    }
    /// Holds the dynamically measured width of the view itself
    @State private var viewSize: CGSize = .zero

    /// Calculates the exact X offset needed to hide the view completely off-screen
    private var startingOffset: CGFloat {
        // 1. Get the current size of the device screen
        let isHorizontal = isHorizontal
        let screenSize = UIWindowScene.currentScreenSize
        let (screenWidth, viewWidth) = isHorizontal
            ? (screenSize.width, viewSize.width)
            : (screenSize.height, viewSize.height)

        // 2. Calculate how wide the view will be when scaled up by 1.15
        // 3. The exact distance to move it completely off-screen:
        // Half of the screen + half of the scaled view
        let requiredOffset = (screenWidth + viewWidth * Constants.scale) / 2

        // 4. Return negative for left side, positive for right side
        return [.leading, .top].contains(edge) ? -requiredOffset : requiredOffset
    }

    func body(content: Content) -> some View {
        content
            // Invisibly measure the width of the view in the background
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ViewSizeKey.self, value: geometry.size)
                }
            )
            .onPreferenceChange(ViewSizeKey.self) { self.viewSize = $0 }
            // Apply the dynamic starting offset
            .offset(x: isAnimating || !isHorizontal ? .zero : startingOffset, // Horizontal while not animating only
                    y: isAnimating || isHorizontal ? .zero : startingOffset ) // Vertical while not animating only
            // Apply the scale
            .scaleEffect(isAnimating ? 1 : Constants.scale)
            // Animate all changes
            .animation(
                .spring(duration: Constants.animationDuration, bounce: isHorizontal ? 0.4 : 0.2),
                value: isAnimating
            )
    }
}

// MARK: - Helpers
private extension CGSize {
    static func * (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    static func / (_ lhs: CGSize, _ rhs: CGFloat) -> CGSize {
        CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
    }
}

private struct ViewSizeKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        let next = nextValue()
        guard value != next else { return }
        value = next
    }
}
