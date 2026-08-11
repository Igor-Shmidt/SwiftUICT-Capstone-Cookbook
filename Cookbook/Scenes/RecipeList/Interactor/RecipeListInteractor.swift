//
//  RecipeListInteractor.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import Foundation

/// The Interactor handles business logic, like fetching data from the repository.
final class RecipeListInteractor: RecipeListBusinessLogic {
    
    var presenter: RecipeListPresentationLogic?
    let repository: RecipeRepository
    
    init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    // MARK: - Business Logic
    
    func fetchRecipes(request: Request) async {
        do {
            // Fetch recipes from the data layer
            let response = try await Response(
                recipes: repository.fetchRecipes()
            )

            // Pass the Response model
            presenter?.presentRecipes(response: response)
            
        } catch {
            // In a full app, we would handle the error and pass it to the presenter here
            print("Error fetching recipes: \(error)")
        }
    }
}
