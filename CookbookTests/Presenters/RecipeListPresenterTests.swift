//
//  RecipeListPresenterTests.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


internal import Foundation
import Testing
@testable import    class SwiftUICT_Capstone_Cookbook.RecipeListPresenter
@testable import    protocol SwiftUICT_Capstone_Cookbook.RecipeListDisplayLogic
@testable import    protocol SwiftUICT_Capstone_Cookbook.RecipeListPresentationLogic
@testable import    protocol SwiftUICT_Capstone_Cookbook.RecipeRepository
@testable import    struct SwiftUICT_Capstone_Cookbook.DetailedRecipe
@testable import    struct SwiftUICT_Capstone_Cookbook.Ingredient
@testable import    struct SwiftUICT_Capstone_Cookbook.Recipe
@testable import    struct SwiftUICT_Capstone_Cookbook.RecipeStep

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
    @Test("List Presenter formats raw recipes into view models correctly")
    func testPresentRecipes() async throws {
        // Given: A presenter connected to a mock view, and some raw recipe data
        let rawRecipe = Recipe(id: 1, name: "Test Pizza", yield: 2.5, uom: .each, category: .pizza)
        let response = RecipeListPresentationLogic.Response(recipes: [rawRecipe])

        // When: The presenter is asked to format the data
        await presenter.presentRecipes(response: response)

        await withTaskGroup { group in
            group.addTask { // Timeout task
                try? await Task.sleep(for: .milliseconds(100))
            }
            group.addTask { @MainActor in
                while (!mockView.displayRecipesCalled) {
                    // Yield execution to allow Task @MainActor to execute
                    await Task.yield()
                }
            }
            await group.next() // wait only one task finish
            group.cancelAll() // cancel other task
        }

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
        var passedViewModel: ViewModel?

        func displayRecipes(viewModel: ViewModel) {
            displayRecipesCalled = true
            passedViewModel = viewModel
        }
    }
}
