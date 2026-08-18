//
//  RecipeListModels.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import Foundation

/// Models for the Recipe List VIP cycle
enum RecipeListModels {
    enum FetchRecipes {
        struct Request {}

        struct Response {
            let recipes: [Recipe]
        }

        struct ViewModel {
            struct RecipeItem: Identifiable {
                let id: Int
                let name: String
                let formattedYield: String
                let categoryName: String
            }
            let items: [RecipeItem]
        }
    }

    enum DeleteRecipes {
        struct Request {
            let recipeIDs: [Int]
        }
    }
}
