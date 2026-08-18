//
//  AppRouter.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import SwiftUI

/// Defines all possible navigation destinations in the app.
enum AppRoute: Hashable {
    case recipesList
    case recipeDetails(recipeID: Int)
    case recipeEditor(recipeID: Int?)
    // case settings
}

/// The Router handles navigation state and acts as a View Factory.
/// This keeps our Views clean and decoupled from Modules.
@MainActor
@Observable
final class AppRouter {
    var path = NavigationPath()
    
    // MARK: - View Factory
    
    /// Resolves a route into a fully configured SwiftUI View.
    /// - Parameter route: The destination route.
    /// - Returns: The assembled VIP View.
    @ViewBuilder
    func destination(for route: AppRoute) -> some View {
        // Only the Router knows about the Modules!
        switch route {
        case .recipesList: RecipeListModule.build()
        case let .recipeDetails(recipeID): RecipeDetailsModule.biuild(for: recipeID)
        case let .recipeEditor(recipeID): RecipeDetailsModule.buildEditor(for: recipeID)
        }
    }

    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)

    }
}
