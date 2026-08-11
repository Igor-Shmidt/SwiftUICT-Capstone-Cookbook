//
//  AppDIContainer.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 10.08.2026.
//


import Foundation
import SwiftUI

/// A simple Dependency Injection container to hold our core data models.
@MainActor
final class AppDIContainer {
    
    /// The shared singleton instance of the DI container
    static let shared = AppDIContainer()
    
    // Core data models initialized
    let recipesData = Recipes()
    let ingredientsData = Ingredients()
    let recipeStepsData = RecipeSteps()
    
    private init() {
        // Private initialization ensures only one instance is created
    }
}
