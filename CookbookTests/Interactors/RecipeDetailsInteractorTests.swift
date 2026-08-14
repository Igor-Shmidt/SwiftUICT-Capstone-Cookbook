//
//  RecipeDetailsInteractorTests.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


internal import Foundation
import Testing
@testable import struct SwiftUICT_Capstone_Cookbook.DetailedRecipe
@testable import struct SwiftUICT_Capstone_Cookbook.Recipe
@testable import protocol SwiftUICT_Capstone_Cookbook.RecipeDetailsBusinessLogic
@testable import protocol SwiftUICT_Capstone_Cookbook.RecipeDetailsPresentationLogic
@testable import class SwiftUICT_Capstone_Cookbook.RecipeDetailsInteractor
@testable import protocol SwiftUICT_Capstone_Cookbook.RecipeRepository
@testable import class SwiftUICT_Capstone_Cookbook.RecipeSteps

@Suite("Recipe Details Interactor Tests")
struct RecipeDetailsInteractorTests {
    private let dummyRecipe = Recipe(id: 1, name: "Test Recipe", yield: 1, uom: .each, category: .pizza)
    private let repository: RecipeRepository
    private let interactor: RecipeDetailsBusinessLogic
    private let mockPresenter = MockRecipeDetailsPresenter()

    @MainActor
    init() async {
        let dummyDetailedRecipe = DetailedRecipe(
            recipe: dummyRecipe,
            steps: RecipeSteps().table,
            ingredientsMap: [:]
        )
        repository = MockRecipeDetailsRepository(mockResult: dummyDetailedRecipe)
        let interactor = RecipeDetailsInteractor(repository: repository)
        interactor.presenter = mockPresenter
        self.interactor = interactor
    }
}

// MARK: - Mocks
extension RecipeDetailsInteractorTests {
    /// A mock repository that returns a predefined result so we don't rely on the actual data layer.
    struct MockRecipeDetailsRepository: RecipeRepository {
        let mockResult: DetailedRecipe

        func fetchRecipes() async throws -> [Recipe] { throw CancellationError() }

        func fetchDetails(for recipeID: Int) async throws -> DetailedRecipe {
            return mockResult
        }
    }

    /// A mock presenter to verify that the Interactor correctly calls the presentation logic.
    final class MockRecipeDetailsPresenter: RecipeDetailsPresentationLogic {
        var presentDetailsCalled = false
        var passedResponse: Response?

        func presentDetails(response: Response) {
            presentDetailsCalled = true
            passedResponse = response
        }
    }
}

// MARK: - Tests
extension RecipeDetailsInteractorTests {
    @Test("Details Interactor successfully fetches details and passes them to the presenter")
    func testFetchDetails() async throws {
        // Given: Setup mocks and interactor
        let request = await RecipeDetailsBusinessLogic.Request(
            recipeID: dummyRecipe.id
        )

        // When: The interactor processes the request
        await interactor.fetchDetails(request: request)

        // Then: The presenter must be called with the correct data
        #expect(mockPresenter.presentDetailsCalled == true, "Presenter should be triggered.")

        let passedResponse = try #require(
            mockPresenter.passedResponse, "Response should not be nil."
        )

        await #expect(
            passedResponse.recipe.id == dummyRecipe.id,
            "The passed recipe ID should match the mock data."
        )

        await #expect(!passedResponse.steps.isEmpty)
    }
}
