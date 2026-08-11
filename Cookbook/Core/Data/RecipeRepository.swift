//
//  RecipeRepository.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//

import Foundation

/// A protocol defining the contract for recipe data operations.
/// Using async/throws prepares the app for future database or network integrations.
protocol RecipeRepository {

    /// Fetches all available recipes.
    /// - Returns: An array of Recipe objects.
    func fetchRecipes() async throws -> [Recipe]

    /// Fetches Detailed Recipe for provided Recipe Id
    /// - Returns: `DetailedRecipe` object or throws error if not found
    func fetchDetails(for recipeID: Int) async throws -> DetailedRecipe
}
