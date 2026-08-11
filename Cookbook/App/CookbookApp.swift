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
            // For now, just a placeholder text. We will replace this with RecipeListView later.
            Text("Cookbook Architecture Ready!")
                .font(.largeTitle)
                .bold()
                .padding()
        }
    }
}
