//
//  RecipeListInteractorTests.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import Testing
@testable import class      SwiftUICT_Capstone_Cookbook.AppDIContainer
@testable import class      SwiftUICT_Capstone_Cookbook.Recipes
@testable import class      SwiftUICT_Capstone_Cookbook.RecipeListInteractor
@testable import protocol   SwiftUICT_Capstone_Cookbook.RecipeListBusinessLogic
@testable import protocol   SwiftUICT_Capstone_Cookbook.RecipeListPresentationLogic
@testable import protocol   SwiftUICT_Capstone_Cookbook.RecipeRepository
@testable import struct     SwiftUICT_Capstone_Cookbook.Recipe

@Suite("Recipe List Interactor Tests")
struct RecipeListInteractorTests {
    private let mockDataSource: Recipes
    private let repository: RecipeRepository
    private let interactor: RecipeListBusinessLogic
    private let mockPresenter = MockRecipeListPresenter()

    @MainActor
    init() async {
        mockDataSource = Recipes()
        repository = AppDIContainer(recipes: mockDataSource).recipeRepository
        let interactor = RecipeListInteractor(repository: repository)
        interactor.presenter = mockPresenter
        self.interactor = interactor
    }
}

extension RecipeListInteractorTests {
    @Test("List Interactor successfully fetches recipes and passes them to the presenter")
    func testFetchRecipes() async throws {
        // Given: A repository and an interactor connected to a mock presenter
        
        // When: The fetch request is made
        await interactor.fetchRecipes(request: .init())

        // Then: The presenter should receive the recipes
        #expect(mockPresenter.presentRecipesCalled, "Presenter should be called")
        let expectedCount = await mockDataSource.table.count
        #expect(mockPresenter.passedRecipes.count == expectedCount,
                "Presenter should receive \(expectedCount) preloaded recipes")
    }
}

// MARK: Mocks
private extension RecipeListInteractorTests {
    // A mock presenter to verify the 'Then' condition
    final class MockRecipeListPresenter: RecipeListPresentationLogic {
        var presentRecipesCalled = false
        var passedRecipes: [Recipe] = []

        func presentRecipes(response: Response) {
            presentRecipesCalled = true
            passedRecipes = response.recipes
        }
    }
}
