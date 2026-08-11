//
//  RecipeListModule.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import Foundation
import SwiftUI

/// Assembles the VIP cycle for the Recipe List scene.
@MainActor
enum RecipeListModule {
    
    /// Configures and returns the fully assembled Recipe List View.
    static func build() -> some View {
        // 1. Create the View State (Display Logic)
        let viewState = RecipeListModels.ViewState()
        
        // 2. Create the Presenter
        let presenter = RecipeListPresenter()
        // Link Presenter -> ViewState
        presenter.view = viewState
        
        // 3. Create the Interactor
        let repository = AppDIContainer.shared.recipeRepository
        let interactor = RecipeListInteractor(repository: repository)
        // Link Interactor -> Presenter
        interactor.presenter = presenter
        
        // 4. Return the View injected with Interactor and ViewState
        return RecipeListView(interactor: interactor, viewState: viewState)
    }
}
