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
    let table: [Recipe]

    /// Initializes the repository with a specific data source.
    /// - Parameter dataSource: The Recipes data model.
    init(dataSource: Recipes) {
        self.table = dataSource.table
    }
    
    /// Fetches all recipes from the local data source.
    func fetchRecipes() async throws -> [Recipe] {
        // We simply return the 'table' array from the Recipes class.
        // In the future, this is where a database fetch would happen.
        return table
    }
}
