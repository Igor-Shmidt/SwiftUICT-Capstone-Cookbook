//
//  RecipeListView.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//


import SwiftUI

extension RecipeListModels {
    /// The observable state container for the Recipe List view.
    /// It conforms to DisplayLogic to receive formatted data from the Presenter.
    @MainActor
    @Observable
    final class ViewState: RecipeListDisplayLogic {

        /// The formatted items to be displayed in the UI.
        var items: [ViewModel.RecipeItem] = []

        /// Indicates if the view is currently loading data.
        var isLoading: Bool = true

        // MARK: - Display Logic

        func displayRecipes(viewModel: ViewModel) {
            self.items = viewModel.items
            self.isLoading = false
        }
    }
}

/// The main view displaying the list of recipes.
struct RecipeListView: View {

    let interactor: RecipeListBusinessLogic

    @State var viewState: RecipeListModels.ViewState

    // Tracks the currently selected recipe for navigation.
    @State private var selectedRecipeId: Int?

    var body: some View {
        // NavigationSplitView automatically handles iPad (Split) and iPhone (Stack) layouts.
        NavigationSplitView {
            ZStack {
                // Apply our semantic background color
                Color.Theme.background.ignoresSafeArea()

                ScrollView {
                    // LazyVStack is more customizable than standard List
                    LazyVStack(spacing: 16) {
                        ForEach(viewState.items) { item in
                            // NavigationLink triggers stack push on iPhone and selection on iPad
                            NavigationLink(value: item.id) {
                                recipeRow(for: item)
                            }
                            // Use the custom interactive button style we created
                            .buttonStyle(ScaleButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("CookBook") // Named after the project comments :)
            // Navigation destination drives the stack push when running on iPhone (Compact)
            .navigationDestination(for: Int.self) { recipeId in
                recipeDetailPlaceholder(for: recipeId)
            }
            .task {
                // Fetch data when the view appears (async/await ready)
                await interactor.fetchRecipes(request: RecipeListModels.FetchRecipes.Request())
            }
        } detail: {
            // Detail area drives the split screen when running on iPad (Regular)
            if let selectedId = selectedRecipeId {
                recipeDetailPlaceholder(for: selectedId)
            } else {
                // Use our empty state component from the Design System
                EmptyStateView(
                    icon: "book.pages",
                    message: "Select a recipe to view details."
                )
            }
        }
    }
}
    // MARK: - Subviews
extension RecipeListView {
    typealias ViewModel = RecipeListModels.FetchRecipes.ViewModel
    /// A helper ViewBuilder for displaying detail placeholder text.
    @ViewBuilder
    private func recipeDetailPlaceholder(for recipeId: Int) -> some View {
        Text("Recipe ID: \(recipeId)")
            .font(.title2)
            .foregroundStyle(Color.Theme.secondaryText)
            .navigationTitle("Recipe Details")
            .navigationBarTitleDisplayMode(.inline)
    }

    /// An extracted ViewBuilder for a single recipe row to keep the body clean.
    @ViewBuilder
    private func recipeRow(for item: ViewModel.RecipeItem) -> some View {
        CookbookCard {
            HStack(alignment: .top, spacing: 16) {
                // A styled icon
                ThemedIcon(symbol: "fork.knife.circle", color: Color.Theme.primary)
                    .font(.system(size: 40))
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.name)
                        .lineLimit(2)
                        .font(.headline)
                        .foregroundStyle(Color.Theme.text)
                        .multilineTextAlignment(.leading)

                    Text(item.formattedYield)
                        .font(.subheadline)
                        .foregroundStyle(Color.Theme.secondaryText)
                }
                
                Spacer()

                // Use our custom Category Tag
                CategoryTag(text: item.categoryName, color: Color.Theme.primary)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    RecipeListModule.build()
}
