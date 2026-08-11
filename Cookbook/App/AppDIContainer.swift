//
//  AppDIContainer.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//


import Foundation
import SwiftUI

@MainActor protocol DIContainer: AnyObject {
    static var shared: DIContainer { get }
    var recipeRepository: RecipeRepository { get }
}

/// A simple Dependency Injection container to hold our core data models.
@MainActor
final class AppDIContainer: DIContainer {
    /// The shared singleton instance of the DI container
    static let shared: DIContainer = AppDIContainer()

    // Core data models initialized
    private let recipesData: Recipes
    private let ingredientsData: Ingredients
    private let recipeStepsData: RecipeSteps

    // MARK: - Repositories

    /// Provides the RecipeRepository for the application.
    var recipeRepository: RecipeRepository {
        LocalRecipeRepository(
            recipesData: recipesData,
            recipeStepsData: recipeStepsData,
            ingredientsData: ingredientsData
        )
    }
#if DEBUG // for Testing purposes
    internal init(
        recipes: Recipes? = nil,
        ingredients: Ingredients? = nil,
        recipeSteps: RecipeSteps? = nil
    ) {
        recipesData = recipes ?? .init()
        ingredientsData = ingredients ?? .init()
        recipeStepsData = recipeSteps ?? .init()
    }
#else
    // Private initialization ensures only one instance is created
    private init() {
        self.recipesData = .init()
        self.ingredientsData = .init()
        self.recipeStepsData = .init()
    }
#endif
}

