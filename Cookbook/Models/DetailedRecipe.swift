//
//  DetailedRecipe.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


/// Composite model returned by the repository
struct DetailedRecipe {
    let recipe: Recipe
    let steps: [RecipeStep]
    let ingredientsMap: [Int: Ingredient]
}
