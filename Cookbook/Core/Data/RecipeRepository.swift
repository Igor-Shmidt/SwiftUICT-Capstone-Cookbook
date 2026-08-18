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

    /// Fetches a single recipe by its identifier.
    /// - Parameter recipeID: The identifier of the recipe to fetch.
    /// - Returns: A Recipe object.
    func fetchRecipe(for recipeID: Int) async throws -> Recipe

    /// Adds a new recipe.
    /// - Parameter recipe: The recipe values to persist.
    /// - Returns: The persisted Recipe object with its assigned identifier.
    func addRecipe(_ recipe: Recipe) async throws -> Recipe

    /// Updates an existing recipe.
    /// - Parameter recipe: The recipe values to persist.
    /// - Returns: The persisted Recipe object.
    func updateRecipe(_ recipe: Recipe) async throws -> Recipe

    /// Deletes an existing recipe.
    /// - Parameter recipeID: The identifier of the recipe to delete.
    func deleteRecipe(id recipeID: Int) async throws
}
