//
//  RecipeDetailsPresenterTests.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import Testing
@testable import    class SwiftUICT_Capstone_Cookbook.RecipeDetailsPresenter
@testable import    protocol SwiftUICT_Capstone_Cookbook.RecipeDetailsDisplayLogic
@testable import    protocol SwiftUICT_Capstone_Cookbook.RecipeDetailsPresentationLogic
@testable import    protocol SwiftUICT_Capstone_Cookbook.RecipeRepository
@testable import    enum SwiftUICT_Capstone_Cookbook.RecipeDetailsModels
@testable import    struct SwiftUICT_Capstone_Cookbook.DetailedRecipe
@testable import    struct SwiftUICT_Capstone_Cookbook.Ingredient
@testable import    struct SwiftUICT_Capstone_Cookbook.Recipe
@testable import 	struct SwiftUICT_Capstone_Cookbook.RecipeStep

@Suite("Recipe Details Presenter Tests")
struct RecipeDetailsPresenterTests {
    private let presenter: RecipeDetailsPresentationLogic
    private let mockView: MockRecipeDetailsView
    @MainActor
    init() async {
        mockView = MockRecipeDetailsView()
        let presenter = RecipeDetailsPresenter()
        presenter.view = mockView
        self.presenter = presenter
    }
}

private extension RecipeDetailsPresenterTests {
    final class MockRecipeDetailsView: RecipeDetailsDisplayLogic {
        var displayDetailsCalled = false
        var displayEditableRecipeCalled = false
        var displaySavedRecipeCalled = false
        var displayedViewModel: ViewModel?

        func displayDetails(viewModel: ViewModel) {
            displayedViewModel = viewModel
            displayDetailsCalled = true
        }

        func displayEditableRecipe(viewModel: RecipeDetailsModels.FetchRecipe.ViewModel) {
            displayEditableRecipeCalled = true
        }

        func displaySavedRecipe(viewModel: RecipeDetailsModels.SaveRecipe.ViewModel) {
            displaySavedRecipeCalled = true
        }
    }
}

extension RecipeDetailsPresenterTests {
    @Test("Details Presenter correctly separates ingredients and step instructions")

    func testPresentDetails() async throws {
        // Given: Presenter with mock view and sample response
        let sampleRecipe = Recipe(id: 1, name: "Test Dough", yield: 500, uom: .gram, category: .prep)
        let sampleIngredient = Ingredient(id: 10, itemName: "Flour", uom: .gram, category: .dry)
        
        let steps = [
            RecipeStep(recipeID: 1, rowID: 0, itemCode: 10, quantity: 300, actions: "", isAction: false),
            RecipeStep(recipeID: 1, rowID: 1, itemCode: 0, quantity: 0, actions: "Mix well", isAction: true)
        ]
        
        let response = RecipeDetailsPresentationLogic.Response(
            recipe: sampleRecipe,
            steps: steps,
            ingredientsMap: [10: sampleIngredient]
        )
        
        // When: Presenting details
        await presenter.presentDetails(response: response)

        await withTaskGroup { group in
            group.addTask { // Timeout task
                try? await Task.sleep(for: .milliseconds(100))
            }
            group.addTask { @MainActor in
                while (!mockView.displayDetailsCalled) {
                    // Yield execution to allow Task @MainActor to execute
                    await Task.yield()
                }
            }
            await group.next() // wait only one task finish
            group.cancelAll() // cancel other task
        }

        // Then: View model should contain exactly 1 ingredient and 1 instruction
        await #expect(mockView.displayDetailsCalled)
        let vm = try await #require(mockView.displayedViewModel)
        await #expect(vm.title == sampleRecipe.name)
        await #expect(vm.ingredients.count == 1)
        await #expect(vm.ingredients.first?.name == sampleIngredient.itemName)
        await #expect(vm.instructions.count == 1)
        await #expect(vm.instructions.first?.description == steps.last?.actions)
    }
}
