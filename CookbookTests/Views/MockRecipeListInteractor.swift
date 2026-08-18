//
//  MockRecipeListInteractor.swift
//  Cookbook
//
//  Created by Igor Shmidt on 13.08.2026.
//


@testable import protocol SwiftUICT_Capstone_Cookbook.RecipeListBusinessLogic
@testable import enum SwiftUICT_Capstone_Cookbook.RecipeListModels

final class MockRecipeListInteractor: RecipeListBusinessLogic {
    private(set) var calls: [RecipeListBusinessLogic.Request] = []

    func fetchRecipes(request: RecipeListBusinessLogic.Request) async {
        calls.append(request)
        // Intentionally do nothing; tests will drive ViewState directly
    }

    func deleteRecipes(request: RecipeListModels.DeleteRecipes.Request) async {
        // Intentionally do nothing; tests will drive ViewState directly
    }
}
