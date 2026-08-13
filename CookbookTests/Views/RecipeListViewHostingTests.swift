//
//  RecipeListViewHostingTests.swift
//  Cookbook
//
//  Created by Igor Shmidt on 13.08.2026.
//


import Testing
@testable import SwiftUICT_Capstone_Cookbook
internal import SwiftUI

@Suite("RecipeListView Hosting Tests")
@MainActor
struct RecipeListViewHostingTests {
    let interactor = MockRecipeListInteractor()
    let state = RecipeListModels.ViewState()
    let router = AppRouter()
}

extension RecipeListViewHostingTests {
    @Test("List view triggers interactor on appear and supports state transitions")
    func listViewLifecycleAndStates() async throws {
        // Given a mock interactor and a fresh view state
        // And a hosted view
        let view = RecipeListView(interactor: interactor, viewState: state)
            .environment(router)
        let (window, _) = hostInWindow(view)

        // When: give SwiftUI time to run .task (on appear)
        pumpRunLoop()

        // Then: interactor was called once
        #expect(interactor.calls.count == 1)

        // When: simulate loading state (already true by default)
        state.isLoading = true
        pumpRunLoop()

        // When: simulate empty state
        state.isLoading = false
        state.items = []
        pumpRunLoop()

        // When: simulate non-empty state
        state.isLoading = true
        state.items = [
            RecipeListDisplayLogic.ViewModel.RecipeItem(
                id: 1,
                name: "Test Pizza",
                formattedYield: "2 servings", 
                categoryName: "Pizza"
            )
        ]
        pumpRunLoop()

        state.isLoading = false
        pumpRunLoop()

        // Cleanup
        window.resignKey()
        window.rootViewController = nil
        window.windowScene = nil
    }
}
