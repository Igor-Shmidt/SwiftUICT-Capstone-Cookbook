//
//  ViewModifiers.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//


import SwiftUI

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

extension View {
    /// Applies a liquid glass effect to the view.
    /// - Parameter cornerRadius: The radius for the rounded corners (default is 16).
    func liquidGlass(cornerRadius: CGFloat = 16) -> some View {
        modifier(LiquidGlassModifier(cornerRadius: cornerRadius))
    }
}
