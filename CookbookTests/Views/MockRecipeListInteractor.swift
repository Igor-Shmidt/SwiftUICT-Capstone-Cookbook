//
//  MockRecipeListInteractor.swift
//  Cookbook
//
//  Created by Igor Shmidt on 13.08.2026.
//


internal import Foundation
@testable import SwiftUICT_Capstone_Cookbook

final class MockRecipeListInteractor: RecipeListBusinessLogic {
    private(set) var calls: [RecipeListBusinessLogic.Request] = []

    func fetchRecipes(request: RecipeListBusinessLogic.Request) async {
        calls.append(request)
        // Intentionally do nothing; tests will drive ViewState directly
    }
}
