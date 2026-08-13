//
//  RecipeDetailsViewHostingTests.swift
//  Cookbook
//
//  Created by Igor Shmidt on 13.08.2026.
//


import Testing
@testable import SwiftUICT_Capstone_Cookbook
internal import SwiftUI

@Suite("RecipeDetailsView Hosting Tests")
@MainActor
struct RecipeDetailsViewHostingTests {
    let interactor = MockRecipeDetailsInteractor()
    let state = RecipeDetailsModels.ViewState()
    let router = AppRouter()
}

extension RecipeDetailsViewHostingTests {
    @Test("Details view triggers interactor on appear and supports state transitions")
    func detailsViewLifecycleAndStates() async throws {
        // Given a mock interactor and a fresh view state
        // And a hosted view
        let view = RecipeDetailsView(
            recipeID: 1,
            interactor: interactor,
            viewState: state
        ).environment(router)
        let (window, _) = hostInWindow(view)

        // When: give SwiftUI time to run .task (on appear)
        pumpRunLoop()

        // Then: interactor was called once
        #expect(interactor.calls.count == 1)

        // Loading state (default true)
        state.isLoading = true
        pumpRunLoop()

        // Empty/error state
        state.isLoading = false
        state.viewModel = nil
        pumpRunLoop()

        // Non-empty state: provide a minimal valid view model
        state.isLoading = true
        state.viewModel = RecipeDetailsModels.FetchDetails.ViewModel(
            title: "Test Dough",
            categoryName: "prep",
            formattedYield: "Yield: 1 each",
            ingredients: [
                .init(id: 1, name: "Flour", formattedAmount: "300 g")
            ],
            instructions: [
                .init(id: 2, stepNumber: 1, description: "Mix well")
            ]
        )
        pumpRunLoop()

        state.isLoading = false
        pumpRunLoop()

        // Cleanup
        window.resignKey()
        window.rootViewController = nil
        window.windowScene = nil
    }
}
