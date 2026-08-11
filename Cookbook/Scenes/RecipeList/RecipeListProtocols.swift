//
//  RecipeListProtocols.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import Foundation

/// Business Logic (Interactor) interface
protocol RecipeListBusinessLogic {
    typealias Request = RecipeListModels.FetchRecipes.Request
    typealias Response = RecipeListModels.FetchRecipes.Response

    func fetchRecipes(request: RecipeListModels.FetchRecipes.Request) async
}

/// Presentation Logic (Presenter) interface
protocol RecipeListPresentationLogic {
    typealias Response = RecipeListModels.FetchRecipes.Response
    func presentRecipes(response: Response)
}

/// Display Logic (View) interface
@MainActor
protocol RecipeListDisplayLogic {
    typealias ViewModel = RecipeListModels.FetchRecipes.ViewModel
    func displayRecipes(viewModel: ViewModel)
}
