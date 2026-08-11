//
//  RecipeListPresenterTests.swift
//  Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


internal import Foundation
@testable import SwiftUICT_Capstone_Cookbook
import Testing

@Suite("Recipe List Presenter Tests")
struct RecipeListPresenterTests {
    private let presenter: RecipeListPresentationLogic
    private let mockView: MockRecipeListView


    @MainActor
    init() async {
        mockView = MockRecipeListView()
        let presenter = RecipeListPresenter()
        presenter.view = mockView
        self.presenter = presenter
    }
}

extension RecipeListPresenterTests {
    @Test("Presenter formats raw recipes into view models correctly")
    func testPresentRecipes() async throws {
        // Given: A presenter connected to a mock view, and some raw recipe data

        
        let rawRecipe = Recipe(id: 1, name: "Test Pizza", yield: 2.5, uom: .each, category: .pizza)
        let response = RecipeListModels.FetchRecipes.Response(recipes: [rawRecipe])
        
        // When: The presenter is asked to format the data
        await presenter.presentRecipes(response: response)

        // Then: The view should receive formatted view models
        await #expect(mockView.displayRecipesCalled == true)
        let item = try await #require(mockView.passedViewModel?.items.first)
        await #expect(item.name == rawRecipe.name)
        await #expect(item.formattedYield == "Yield: \(rawRecipe.yield.formatted()) \(rawRecipe.uom.rawValue)")
        await #expect(item.categoryName == rawRecipe.category.rawValue)
    }
}

// MARK: Mocks
private extension RecipeListPresenterTests {
    // A mock view to verify the 'Then' condition
    final class MockRecipeListView: RecipeListDisplayLogic {
        var displayRecipesCalled = false
        var passedViewModel: RecipeListModels.FetchRecipes.ViewModel?

        func displayRecipes(viewModel: RecipeListModels.FetchRecipes.ViewModel) {
            displayRecipesCalled = true
            passedViewModel = viewModel
        }
    }
}
