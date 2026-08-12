//
//  CookbookApp.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//

import SwiftUI

@main
struct CookbookApp: App {
    // Create the central Router for the app
    @State private var router = AppRouter()
    @State private var splashFinished = false

    var body: some Scene {
        WindowGroup {
            if splashFinished {
                router.destination(for: .recipesList)
            } else {
                SplashScreenView(isFinished: $splashFinished)
            }
        }.environment(router)
    }
}
