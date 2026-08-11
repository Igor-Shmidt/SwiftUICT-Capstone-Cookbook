//
//  CookbookApp.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//

import SwiftUI

@main
struct CookbookApp: App {
    // Inject our global dependencies
    let diContainer = AppDIContainer.shared

    var body: some Scene {
        WindowGroup {
            RecipeListModule.build()
        }
    }
}
