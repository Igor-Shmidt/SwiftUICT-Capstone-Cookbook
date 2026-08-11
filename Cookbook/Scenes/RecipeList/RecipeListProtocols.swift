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
    func presentRecipes(response: RecipeListModels.FetchRecipes.Response)
}
