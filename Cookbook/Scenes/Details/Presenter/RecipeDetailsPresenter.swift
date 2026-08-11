//
//  RecipeDetailsPresenter.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import Foundation

/// Presenter formatting raw recipe steps into separated ingredients and instruction steps
final class RecipeDetailsPresenter: RecipeDetailsPresentationLogic {

    var view: RecipeDetailsDisplayLogic?

    func presentDetails(response: Response) {
        let recipe = response.recipe

        // Filter ingredient steps vs action steps
        let ingredientSteps = response.steps.filter { !$0.isAction }
        let actionSteps = response.steps.filter(\.isAction)

        // Format ingredients
        let ingredientItems = ingredientSteps.map { step -> ViewModel.IngredientItem in
            let ingredientName = response.ingredientsMap[step.itemCode]?.itemName ?? "Unknown Ingredient"
            let uomSymbol = response.ingredientsMap[step.itemCode]?.uom.rawValue ?? ""
            let amountString = step.quantity > 0 ? "\(step.quantity.formatted()) \(uomSymbol)" : ""
            let noteString = step.actions.isEmpty ? "" : " (\(step.actions))"
            
            return RecipeDetailsModels.FetchDetails.ViewModel.IngredientItem(
                id: step.id,
                name: ingredientName + noteString,
                formattedAmount: amountString
            )
        }

        // Format action instructions in sequential order
        let actionItems = actionSteps.enumerated().map { index, step in
            RecipeDetailsModels.FetchDetails.ViewModel.ActionItem(
                id: step.id,
                stepNumber: index + 1,
                description: step.actions
            )
        }

        let viewModel = RecipeDetailsModels.FetchDetails.ViewModel(
            title: recipe.name,
            categoryName: recipe.category.rawValue,
            formattedYield: "Yield: \(recipe.yield.formatted()) \(recipe.uom.rawValue)",
            ingredients: ingredientItems,
            instructions: actionItems
        )

        Task { @MainActor in
            view?.displayDetails(viewModel: viewModel)
        }
    }
}
