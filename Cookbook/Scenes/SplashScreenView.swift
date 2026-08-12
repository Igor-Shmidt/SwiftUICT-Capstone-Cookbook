//
//  SplashScreenView.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 12.08.2026.
//


import SwiftUI

/// The initial splash screen displayed when opening the app.
struct SplashScreenView: View {
    @State private var isAnimating: Bool = false
    @Binding var isFinished: Bool
    @Environment(AppRouter.self) private var router

    var body: some View {
        if isFinished { EmptyView() }
        else {
            ZStack {
                // Apply theme background
                Color.Theme.background.ignoresSafeArea()

                VStack(spacing: 24) {
                    // Animated cookbook icon
                    AppIconBig()
                        .animatedSlideIn(isAnimating: isAnimating, from: .top)
                        .animatedBreathe(isAnimating)

                    VStack(spacing: 8) {
                        Text("Capstone: Cookbook")
                            .font(.system(.largeTitle, design: .serif))
                            .bold()
                            .foregroundStyle(Color.Theme.text)
                            .animatedSlideIn(isAnimating: isAnimating, from: .leading)

                        Text("Your Personal Culinary Journal")
                            .font(.subheadline)
                            .foregroundStyle(Color.Theme.secondaryText)
                            .animatedSlideIn(isAnimating: isAnimating, from: .bottom)
                    }
                }
            }
            .task {
                // Start the timer when the screen appears
                isAnimating = true
                try? await Task.sleep(for: .seconds(2.4))
                withAnimation(.easeOut(duration: 0.8)) {
                    isFinished = true
                }
            }
        }
    }
}


#Preview {
    let router = AppRouter()
    SplashScreenView(isFinished: .constant(false))
        .environment(router)
}
