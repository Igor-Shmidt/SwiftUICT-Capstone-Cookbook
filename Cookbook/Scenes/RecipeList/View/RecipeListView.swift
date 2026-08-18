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

        var isAnimating: Bool = false

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

    @Environment(AppRouter.self) private var router

    @State var viewState: RecipeListModels.ViewState

    // Tracks the currently selected recipe for navigation.
    @State private var selectedRecipeId: Int?

    var body: some View {
        // NavigationSplitView automatically handles iPad (Split) and iPhone (Stack) layouts.
        NavigationSplitView {
            ZStack {
                SkyBackground()

                if viewState.isLoading {
                    ProgressView("Opening bookshelf...")
                } else if !viewState.items.isEmpty {
                    List(selection: $selectedRecipeId) {
                        Section {
                            ForEach(viewState.items) { item in
                                Button { selectedRecipeId = item.id }
                                label: { recipeRow(for: item) }
                            }
                            .onDelete(perform: deleteRecipes(at:))
                            .buttonStyle(ScaleButtonStyle())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .animatedSlideIn(
                            isAnimating: viewState.isAnimating,
                            from: .bottom)
                        .task { [viewState] in
                            guard !viewState.isAnimating else { return }
                            await Task.yield()
                            viewState.isAnimating = true
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    Spacer()
                } else {
                    EmptyStateView(icon: "exclamationmark.triangle",
                                   message: "Failed to load recipes.")
                }
            }
            .navigationTitle("CookBook")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: AppRoute.recipeEditor(recipeID: nil)) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add New Recipe")
                }
            }
            // Navigation destination drives the stack push when running on iPhone (Compact)
            .navigationDestination(for: AppRoute.self) { route in
                router.destination(for: route)
            }
            .task {
                // Fetch data when the view appears (async/await ready)
                await interactor.fetchRecipes(request: RecipeListModels.FetchRecipes.Request())
            }
        } detail: {
            @Bindable var router = router
            NavigationStack(path: $router.path) {
                // Detail area drives the split screen when running on iPad (Regular)
                if let selectedId = selectedRecipeId {
                    recipeDetail(for: selectedId)
                        .navigationDestination(for: AppRoute.self) { route in
                            router.destination(for: route)
                        }
                } else {
                    // Use our empty state component from the Design System
                    EmptyStateView(
                        icon: "book.pages",
                        message: "Select a recipe to view details."
                    )
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}
    // MARK: - Subviews
extension RecipeListView {
    typealias ViewModel = RecipeListModels.FetchRecipes.ViewModel
    /// A helper ViewBuilder for displaying detail placeholder text.
    @ViewBuilder
    private func recipeDetail(for recipeId: Int) -> some View {
        router.destination(for: .recipeDetails(recipeID: recipeId))
    }

    private func deleteRecipes(at offsets: IndexSet) {
        let recipeIDs = offsets.map { viewState.items[$0].id }
        Task {
            await interactor.deleteRecipes(request: .init(recipeIDs: recipeIDs))
        }
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
                CategoryTag(text: item.categoryName)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    RecipeListModule.build()
        .environment(AppRouter())
}
