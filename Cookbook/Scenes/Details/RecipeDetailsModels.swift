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
            struct IngredientItem: Identifiable, Equatable {
                let id: Int
                let name: String
                let formattedAmount: String
            }

            struct ActionItem: Identifiable, Equatable {
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

    enum FetchRecipe {
        struct Request {
            let recipeID: Int
        }

        typealias Response = Recipe

        struct ViewModel {
            var id: Int {
                get { recipe.id }
                set { recipe.id = newValue }
            }
            var name: String {
                get { recipe.name }
                set { recipe.name = newValue }
            }
            var yieldText: String {
                get { recipe.yield > 0 ? "\(recipe.yield)" : "" }
                set {
                    guard let yield = try? Double(newValue, format: .number)
                    else { return }
                    recipe.yield = yield
                }
            }

            var unitOfMeasure: UnitOfMeasure {
                get { recipe.uom }
                set { recipe.uom = newValue }
            }

            var category: IngredientCategory {
                get { recipe.category }
                set { recipe.category = newValue }
            }

            static var blank: ViewModel {
                .init()
            }

            var recipe: Recipe = .blank
        }
    }

    enum SaveRecipe {
        struct Request {
            let recipe: Recipe
            let isNewRecipe: Bool
        }

        struct Response {
            let recipe: Recipe
        }

        struct ViewModel {
            let recipeID: Int
        }
    }
}
