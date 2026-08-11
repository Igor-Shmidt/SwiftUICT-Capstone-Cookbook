//
//  RecipeDetailsModels.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import Foundation

/// Data models for the Recipe Details VIP cycle
enum RecipeDetailsModels {

    enum FetchDetails {
        struct Request {
            let recipeID: Int
        }

        typealias Response = DetailedRecipe

        struct ViewModel {
            struct IngredientItem: Identifiable {
                let id: Int
                let name: String
                let formattedAmount: String
            }

            struct ActionItem: Identifiable {
                let id: Int
                let stepNumber: Int
                let description: String
            }

            let title: String
            let categoryName: String
            let formattedYield: String
            let ingredients: [IngredientItem]
            let instructions: [ActionItem]
        }
    }
}


