//
//  RecipeDetailsInteractor.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import Foundation

/// Interactor handling business logic for recipe details
final class RecipeDetailsInteractor: RecipeDetailsBusinessLogic {
    
    var presenter: RecipeDetailsPresentationLogic?
    let repository: RecipeRepository
    
    init(repository: RecipeRepository) {
        self.repository = repository
    }
    
    func fetchDetails(request: Request) async {
        do {
            let response = try await repository.fetchDetails(for: request.recipeID)
            presenter?.presentDetails(response: response)
        } catch {
            print("Error fetching details: \(error)")
        }
    }
}
