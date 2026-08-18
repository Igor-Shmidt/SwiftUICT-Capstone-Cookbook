//
//  RecipeDetailsModule.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import SwiftUI

/// Assembles the VIP cycle for the Recipe Details scene.
@MainActor
enum RecipeDetailsModule {
    
    /// Configures and returns the fully assembled Recipe Details View.
    /// - Parameter recipeID: The ID of the recipe to display.
    static func biuild(for recipeID: Int) -> some View {
        let viewState = RecipeDetailsModels.ViewState()

        let presenter = RecipeDetailsPresenter()
        presenter.view = viewState
        
        let repository = AppDIContainer.shared.recipeRepository
        let interactor = RecipeDetailsInteractor(repository: repository)
        interactor.presenter = presenter
        
        return RecipeDetailsView(
            recipeID: recipeID,
            interactor: interactor,
            viewState: viewState
        )
    }

    /// Configures and returns the fully assembled Recipe Editor View.
    /// - Parameter recipeID: The ID of the recipe to edit, or nil to create a new recipe.
    static func buildEditor(for recipeID: Int?) -> some View {
        let viewState = RecipeDetailsModels.ViewState()

        let presenter = RecipeDetailsPresenter()
        presenter.view = viewState

        let repository = AppDIContainer.shared.recipeRepository
        let interactor = RecipeDetailsInteractor(repository: repository)
        interactor.presenter = presenter

        return RecipeEditorView(
            recipeID: recipeID,
            interactor: interactor,
            viewState: viewState
        )
    }
}
