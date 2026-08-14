//
//  RecipesTests.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//


import Testing
@testable import class SwiftUICT_Capstone_Cookbook.Recipes

/// Test suite for the Recipes data model
@Suite("Recipes Model Tests")
struct RecipesTests {
    
    @Test("Check if preload populates data correctly")
    func testPreloadData() async {
        // Arrange & Act
        let recipesModel = await Recipes() // init() calls preload() automatically

        // Assert
        // We expect 5 recipes to be preloaded based on Recipes.swift
        await #expect(!recipesModel.table.isEmpty)
    }
    
    @Test("Check nextID generation")
    func testNextID() async {
        // Arrange
        let recipesModel = await Recipes()

        // Act
        let next = await recipesModel.nextID
        
        // Assert
        // The max ID in preload data is 5. So the next available ID should be 6.
        #expect(next == 6)
    }
}
