//
//  LocalRecipeRepository.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//


import Foundation

/// A local implementation of the RecipeRepository using in-memory data.
struct LocalRecipeRepository: RecipeRepository {
    
    /// The local data source holding our preloaded recipes.
    let recipesData: Recipes
    let recipeStepsData: RecipeSteps
    let ingredientsData: Ingredients

    /// Initializes the repository with a specific data source.
    /// - Parameter dataSource: The Recipes data model.
    init(recipesData: Recipes, recipeStepsData: RecipeSteps, ingredientsData: Ingredients) {
        self.recipesData = recipesData
        self.recipeStepsData = recipeStepsData
        self.ingredientsData = ingredientsData
    }

    /// Fetches all recipes from the local data source.
    func fetchRecipes() async throws -> [Recipe] {
        // We simply return the 'table' array from the Recipes class.
        // In the future, this is where a database fetch would happen.
        return recipesData.table
    }

    func fetchRecipe(for recipeID: Int) async throws -> Recipe {
        guard let recipe = recipesData.recipe(id: recipeID) else {
            throw RecipeDetailsError.recipeNotFound
        }

        return recipe
    }

    func fetchDetails(for recipeID: Int) async throws -> DetailedRecipe {
        guard let recipe = recipesData.recipe(id: recipeID) else {
            throw RecipeDetailsError.recipeNotFound
        }

        let steps = recipeStepsData.allSteps(for: recipeID)
        if steps.isEmpty { throw RecipeDetailsError.recipeNotFound }

        // Build a mapping dictionary of itemCode -> Ingredient for fast lookup
        var ingredientsMap: [Int: Ingredient] = [:]
        for step in steps where !step.isAction {
            if let ingredient = ingredientsData.ingredient(id: step.itemCode) {
                ingredientsMap[step.itemCode] = ingredient
            }
        }
        if ingredientsMap.isEmpty { throw RecipeDetailsError.recipeNotFound }

        return DetailedRecipe(
            recipe: recipe,
            steps: steps.sorted(using: KeyPathComparator(\.rowID)),
            ingredientsMap: ingredientsMap
        )
    }

    func addRecipe(_ recipe: Recipe) async throws -> Recipe {
        recipesData.addRecipe(recipe: recipe)
    }

    func updateRecipe(_ recipe: Recipe) async throws -> Recipe {
        guard let updatedRecipe = recipesData.updateRecipe(recipe: recipe) else {
            throw RecipeDetailsError.recipeNotFound
        }

        return updatedRecipe
    }

    func deleteRecipe(id recipeID: Int) async throws {
        recipesData.removeRecipe(id: recipeID)
    }
}
