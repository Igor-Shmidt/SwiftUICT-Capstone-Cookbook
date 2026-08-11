//
//  RecipeRepositoryTests.swift
//  Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//


import Testing
@testable import SwiftUICT_Capstone_Cookbook // Use your actual target name here

/// Test suite to verify the behavior of the RecipeRepository.
@Suite("Recipe Repository Tests")
struct RecipeRepositoryTests {
    private let repository: RecipeRepository
    private let mockDataSource: Recipes

    @MainActor
    init() async {
        mockDataSource = Recipes()
        repository = AppDIContainer(recipes: mockDataSource).recipeRepository
    }
}

extension RecipeRepositoryTests {
    @Test("Repository successfully fetches all preloaded recipes")
    func testFetchRecipes() async throws {
        // Given: Setup the data source and the repository done by init

        // When: Fetch the recipes asynchronously
        let fetchedRecipes = try await repository.fetchRecipes()
        
        // Then: Verify we got the expected data
        let expectedCount = await mockDataSource.table.count
        #expect(fetchedRecipes.count == expectedCount, "Expected exactly \(expectedCount) preloaded recipes.")

        // Check if the first recipe matches our preload data
        let (firstRecipeName, expected) = await (
            fetchedRecipes.first?.name, mockDataSource.table.first?.name
        )
        #expect(firstRecipeName == expected, "First recipe should be '\(expected)'.")
    }
}
