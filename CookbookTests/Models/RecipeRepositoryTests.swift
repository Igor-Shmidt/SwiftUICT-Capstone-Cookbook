//
//  RecipeRepositoryTests.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//


import Testing
@testable import class      SwiftUICT_Capstone_Cookbook.AppDIContainer
@testable import class      SwiftUICT_Capstone_Cookbook.Ingredients
@testable import class      SwiftUICT_Capstone_Cookbook.Recipes
@testable import class      SwiftUICT_Capstone_Cookbook.RecipeSteps
@testable import protocol   SwiftUICT_Capstone_Cookbook.RecipeRepository

/// Test suite to verify the behavior of the RecipeRepository.
@Suite("Recipe Repository Tests")
struct RecipeRepositoryTests {
    private let repository: RecipeRepository
    private let mocks = Mocks()

    @MainActor
    init() async {
        repository = AppDIContainer(
            recipes: mocks.recipes,
            ingredients: mocks.ingredients,
            recipeSteps: mocks.steps
        ).recipeRepository
    }
}

extension RecipeRepositoryTests {
    @Test("Repository successfully fetches all preloaded recipes")
    func testFetchRecipes() async throws {
        // Given: Setup the data source and the repository done by init

        // When: Fetch the recipes asynchronously
        let fetchedRecipes = try await repository.fetchRecipes()
        
        // Then: Verify we got the expected data
        let expectedCount = await mocks.recipes.table.count
        #expect(fetchedRecipes.count == expectedCount, "Expected exactly \(expectedCount) preloaded recipes.")

        // Check if the first recipe matches our preload data
        let (firstRecipeName, expected) = await (
            fetchedRecipes.first?.name, mocks.recipes.table.first?.name
        )
        #expect(firstRecipeName == expected, "First recipe should be '\(expected)'.")
    }

    @Test("Repository successfully fetches recipe details, steps, and maps ingredients")
    func testFetchDetailsSuccess() async throws {
        // Given: Data sources with preloaded data
        let targetRecipeID = 1 // Standard Pizza Dough

        // When: Fetching details for recipe ID 1
        let details = try await repository.fetchDetails(for: targetRecipeID)

        // Then: Recipe ID, name, steps, and ingredient mapping must be correct
        let expectedRecipe = try await #require(mocks.recipes.recipe(id: targetRecipeID))
        await #expect(details.recipe.id == expectedRecipe.id)
        await #expect(details.recipe.name == expectedRecipe.name)
        await #expect(!details.steps.isEmpty, "Steps list should not be empty")

        // Verify that ingredient steps correctly resolve to ingredient names from the map
        let firstIngredientStep = try await #require(Task { @MainActor in
            details.steps.first(where: { !$0.isAction })
        }.value)

        let mappedIngredient = await details.ingredientsMap[firstIngredientStep.itemCode]
        #expect(mappedIngredient != nil, "Ingredient mapping should exist for itemCode")

    }
}

private extension RecipeRepositoryTests {
    struct Mocks {
        let recipes = Recipes()
        let steps = RecipeSteps()
        let ingredients = Ingredients()
    }
}
