//
//  StyleGuidePreview.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//

import Foundation
import SwiftUI

/// A preview file to showcase and test our Design System components.
#Preview("Design System - Light/Dark") {
    ZStack {
        // Background
        Color.Theme.background.ignoresSafeArea()

        VStack(spacing: 24) {

            // 1. Standard Card
            CookbookCard {
                HStack {
                    ThemedIcon(symbol: "fork.knife")
                    VStack(alignment: .leading) {
                        Text("Standard Card")
                            .font(.headline)
                            .foregroundStyle(Color.Theme.text)
                        Text("Material and shadows")
                            .font(.subheadline)
                            .foregroundStyle(Color.Theme.secondaryText)
                    }
                    Spacer()
                }
            }

            // 2. Liquid Glass Card
            // We use an image background to demonstrate the glass effect
            ZStack {
                Color.Theme.primary
                    .opacity(0.6)
                    .frame(height: 100)
                    .cornerRadius(16)
                    .rotationEffect(.degrees(5))
                    .padding([.vertical], -5)

                HStack {
                    ThemedIcon(symbol: "flame", color: .cyan)
                    VStack(alignment: .leading) {
                        Text("Liquid Glass Component")
                            .font(.headline)
                        Text("Blurry and beautiful")
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding()
                .liquidGlass(cornerRadius: 16)
            }

        }
        .padding()
    }
    // This allows us to see how components look in both Light and Dark mode side by side
    .preferredColorScheme(.dark)
}
