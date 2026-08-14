//
//  MockRecipeDetailsInteractor.swift
//  Cookbook
//
//  Created by Igor Shmidt on 13.08.2026.
//


@testable import protocol SwiftUICT_Capstone_Cookbook.RecipeDetailsBusinessLogic

final class MockRecipeDetailsInteractor: RecipeDetailsBusinessLogic {
    private(set) var calls: [RecipeDetailsBusinessLogic.Request] = []

    func fetchDetails(request: RecipeDetailsBusinessLogic.Request) async {
        calls.append(request)
        // Intentionally do nothing; tests will drive ViewState directly
    }
}

extension RecipeDetailsBusinessLogic.Request: @retroactive Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.recipeID == rhs.recipeID
    }
}
