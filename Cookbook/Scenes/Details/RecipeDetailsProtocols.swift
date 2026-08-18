//
//  RecipeDetailsProtocols.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//

import Foundation



/// Interactor interface
protocol RecipeDetailsBusinessLogic {
    typealias Request = RecipeDetailsModels.FetchDetails.Request
    typealias Response = RecipeDetailsModels.FetchDetails.Response

    func fetchDetails(request: Request) async
    func fetchRecipe(request: RecipeDetailsModels.FetchRecipe.Request) async
    func saveRecipe(request: RecipeDetailsModels.SaveRecipe.Request) async
}

/// Presenter interface
protocol RecipeDetailsPresentationLogic {
    typealias ViewModel = RecipeDetailsModels.FetchDetails.ViewModel
    typealias Response = RecipeDetailsModels.FetchDetails.Response

    func presentDetails(response: Response)
    func presentEditableRecipe(response: RecipeDetailsModels.FetchRecipe.Response)
    func presentSavedRecipe(response: RecipeDetailsModels.SaveRecipe.Response)
}

/// View Display logic interface
@MainActor
protocol RecipeDetailsDisplayLogic {
    typealias ViewModel = RecipeDetailsModels.FetchDetails.ViewModel

    func displayDetails(viewModel: ViewModel)
    func displayEditableRecipe(viewModel: RecipeDetailsModels.FetchRecipe.ViewModel)
    func displaySavedRecipe(viewModel: RecipeDetailsModels.SaveRecipe.ViewModel)
}
