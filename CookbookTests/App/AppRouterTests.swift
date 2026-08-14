//
//  AppRouterTests.swift
//  SwiftUICT-Capstone-CookbookTests
//
//  Created by Igor Shmidt on 13.08.2026.
//

import Testing
@testable import class SwiftUICT_Capstone_Cookbook.AppRouter
internal import struct      SwiftUI.NavigationPath
internal import protocol    SwiftUI.View

@Suite("AppRouter Tests")
struct AppRouterTests {
    private let router: AppRouter

    @MainActor
    init() {
        self.router = AppRouter()
    }
}

extension AppRouterTests {
    @MainActor
    private func description(for view: some View) -> String {
        String(describing: Mirror(reflecting: view))
    }

    @MainActor
    private func getPathCount() -> Int {
        router.path.count
    }

    @Test("destination(for: .recipesList) builds list")
    func destinationBuildsList() async throws {
        // Given router
        // When call router.destination(for: .recipesList)
        let view = await router.destination(for: .recipesList)

        // Then returned View is RecipeListView
        await #expect(description(for: view).contains("RecipeListView"), "Expected RecipeListView in destination")
    }

    @Test("destination(for: .recipeDetails) builds details")
    func destinationBuildsDetails() async throws {
        // Given router
        // When call router.destination(for: .recipesList)
        let view = await router.destination(for: .recipeDetails(recipeID: 1))

        // Then returned View is RecipeDetailsView
        await #expect(description(for: view).contains("RecipeDetailsView"), "Expected RecipeDetailsView in destination")
    }

    @Test("navigate(to:) appends routes to path")
    func navigateAppendsRoutes() async throws {
        // Given router
        // Ensure clean state
        await router.popToRoot()
        let initialCount = await getPathCount()
        #expect(initialCount == 0, "Path should start empty")

        // When navigating to list
        await router.navigate(to: .recipesList)

        // Then route added to path
        await #expect(getPathCount() == initialCount + 1, "Path should have one element after first navigate")

        // And When navigating to details
        await router.navigate(to: .recipeDetails(recipeID: 1))

        // Then route added to path
        await #expect(getPathCount() == initialCount + 2, "Path should have two elements after second navigate")
    }

    @Test("pop() removes the last route when path is not empty")
    func popRemovesLast() async throws {
        // Given router
        // Ensure clean state
        await router.popToRoot()

        await router.navigate(to: .recipesList)
        await router.navigate(to: .recipeDetails(recipeID: 1))
        // two routes in the path
        await #expect(getPathCount() == 2, "Expected two routes before popping")

        // When popping once
        await router.pop()

        // Then one path component left
        await #expect(getPathCount() == 1, "Expected one route after first pop")

        // And When popping again
        await router.pop()

        // Then path became empty
        await #expect(getPathCount() == 0, "Expected empty path after second pop")

        // And when Popping on empty path
        await router.pop()

        // Then nothing changes
        await #expect(getPathCount() == 0, "Pop on empty path should not change count")
    }

    @Test("popToRoot() clears the navigation path")
    func popToRootClearsPath() async throws {
        // Given router
        // Ensure clean state
        await router.popToRoot()

        await router.navigate(to: .recipesList)
        await router.navigate(to: .recipeDetails(recipeID: 2))
        await router.navigate(to: .recipesList)
        // several routes in the path
        await #expect(getPathCount() > 1, "Path should have at least one element before popToRoot")

        // When popToRoot is called
        await router.popToRoot()

        // Then the path is empty
        await #expect(getPathCount() == 0, "Path should be empty after popToRoot")
    }
}
