//
//  RecipeListPresenter.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import Foundation

/// The Presenter formats raw data into ready-to-use strings for the View.
final class RecipeListPresenter: RecipeListPresentationLogic {
    typealias ViewModel = RecipeListModels.FetchRecipes.ViewModel

    // The view is held weakly or referenced via protocol.
    // In SwiftUI, we often use an Observable class that acts as the DisplayLogic receiver.
    var view: RecipeListDisplayLogic?
    
    // MARK: - Presentation Logic
    
    func presentRecipes(response: Response) {
        guard let view else { return }
        // Map raw Recipe objects to ViewModels
        let viewModel = ViewModel(items: response.recipes.map { recipe in
            .init(
                id: recipe.id,
                name: recipe.name,
                formattedYield: "Yield: \(recipe.yield.formatted()) \(recipe.uom.rawValue)",
                categoryName: recipe.category.rawValue
            )
        })

        // Ensure UI updates happen on the main thread
        Task { @MainActor in view.displayRecipes(viewModel: viewModel) }
    }
}
