//
//  RecipeDetailsView.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 11.08.2026.
//

import Foundation
import SwiftUI

extension RecipeDetailsModels {
    /// The observable state container for the Recipe Details view.
    @MainActor
    @Observable
    final class ViewState: RecipeDetailsDisplayLogic {

        /// The formatted view model containing all data for the UI.
        var viewModel: ViewModel?

        /// Tracks whether the data is currently being fetched.
        var isLoading: Bool = true

        /// Editable recipe values used by the recipe editor screen.
        var editableRecipe: FetchRecipe.ViewModel = .blank

        /// Tracks whether a save request is currently running.
        var isSaving: Bool = false

        /// Indicates that the current editor save completed successfully.
        var didSaveRecipe: Bool = false

        // MARK: - Display Logic

        func displayDetails(viewModel: FetchDetails.ViewModel) {
            self.viewModel = viewModel
            self.isLoading = false
        }

        func displayEditableRecipe(viewModel: FetchRecipe.ViewModel) {
            editableRecipe = viewModel
            isLoading = false
        }

        func displaySavedRecipe(viewModel: SaveRecipe.ViewModel) {
            editableRecipe.id = viewModel.recipeID
            isSaving = false
            didSaveRecipe = true
        }

        // MARK: - Completion Logic
        fileprivate var completedIngredients: IndexSet = []
        fileprivate var completedActions: IndexSet = []

        fileprivate func isCompleted(_ ingredient: FetchDetails.ViewModel.IngredientItem) -> Bool {
            viewModel?.ingredients
                .firstIndex(of: ingredient)
                .map(completedIngredients.contains)
            ?? false
        }

        fileprivate func isCompleted(_ instruction: FetchDetails.ViewModel.ActionItem) -> Bool {
            viewModel?.instructions
                .firstIndex(of: instruction)
                .map(completedActions.contains)
            ?? false
        }

        fileprivate func toggle(_ ingredient: FetchDetails.ViewModel.IngredientItem) {
            guard let index = viewModel?.ingredients.firstIndex(of: ingredient)
            else { return }

            if completedIngredients.contains(index) {
                completedIngredients.remove(index)
            } else {
                completedIngredients.insert(index)
            }
        }

        fileprivate func toggle(_ instruction: FetchDetails.ViewModel.ActionItem) {
            guard let index = viewModel?.instructions.firstIndex(of: instruction)
            else { return }

            if completedActions.contains(index) {
                completedActions.remove(index)
            } else {
                completedActions.insert(index)
            }
        }
    }
}

/// The view displaying the full details, ingredients, and instructions for a recipe.
struct RecipeDetailsView: View {

    let recipeID: Int
    let interactor: RecipeDetailsBusinessLogic
    @Environment(AppRouter.self) private var router
    @State var viewState: RecipeDetailsModels.ViewState

    var body: some View {
        ZStack {
            SkyBackground()

            if viewState.isLoading {
                ProgressView("Warming up the oven...")
            } else if let viewModel = viewState.viewModel {
                List {
                    HeaderSection(viewModel: viewModel)
                    IngredientsSection(ingredients: viewModel.ingredients)
                    InstructionsSection(instructions: viewModel.instructions)
                }
                .listStyle(.plain)
                .listSectionSpacing(.compact)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.never)
            } else {
                EmptyStateView(icon: "exclamationmark.triangle", message: "Failed to load recipe.")
            }
        }
        // Native SwiftUI task modifier triggers the VIP cycle
        .task {
            let request = RecipeDetailsBusinessLogic.Request(recipeID: recipeID)
            await interactor.fetchDetails(request: request)

        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: AppRoute.recipeEditor(recipeID: recipeID)) {
                    Text("Edit")
                }
            }
        }
    }
}

private extension RecipeDetailsView {
    // MARK: - UI Components
    
    @ViewBuilder
    func HeaderSection(
        viewModel: RecipeDetailsModels.FetchDetails.ViewModel
    ) -> some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewModel.title)
                    .font(.system(.largeTitle, design: .serif))
                    .bold()
                    .foregroundStyle(Color.Theme.text)
                    .shadow(color: Color.Theme.background, radius: 8)

                HStack {
                    CategoryTag(text: viewModel.categoryName)
                    Spacer()
                    Text(viewModel.formattedYield)
                        .font(.subheadline)
                        .foregroundStyle(Color.Theme.surface)
                }
            }
            .listRowBackground(EmptyView())
            .listRowSeparator(.hidden)
        }
    }

    @ViewBuilder
    private func IngredientsSection(
        ingredients: [RecipeDetailsModels.FetchDetails.ViewModel.IngredientItem]
    ) -> some View {
        Section {
            ForEach(ingredients) { ingredient in
                IngredientRow(ingredient)
                    .swipeActions {
                        Button {
                            viewState.toggle(ingredient)
                        } label: {
                            Label("", systemImage: viewState.isCompleted(ingredient)
                                  ? "arrow.uturn.backward" : "checkmark")
                        }
                        .tint(.green)
                    }
            }
            .listRowBackground(EmptyView())
            .listRowInsets(.vertical, 4)
        } header: {
            Text("Ingredients")
                .font(.title2)
                .bold()
                .foregroundStyle(Color.Theme.text)
                .shadow(color: Color.Theme.background, radius: 12)
        }
    }

    @ViewBuilder
    private func InstructionsSection(
        instructions: [RecipeDetailsModels.FetchDetails.ViewModel.ActionItem]
    ) -> some View {
        Section {
            ForEach(instructions.enumerated(), id: \.element.id) { offset, instruction in
                InstructionRow(instruction)
                    .swipeActions {
                        Button {
                            viewState.toggle(instruction)
                        } label: {
                            Label("", systemImage: viewState.isCompleted(instruction)
                                  ? "arrow.uturn.backward" : "checkmark")
                        }
                        .tint(.green)
                    }
            }
            .listRowBackground(EmptyView())
            .listRowInsets(.vertical, 4)
        } header: {
            Text("Instructions")
                .font(.title2)
                .bold()
                .foregroundStyle(Color.Theme.text)
                .shadow(color: Color.Theme.background, radius: 12)
        }
    }

    @ViewBuilder
    func IngredientRow(_ ingredient: RecipeDetailsModels.FetchDetails.ViewModel.IngredientItem) -> some View {
        let isCompleted = viewState.isCompleted(ingredient)
        CookbookCard {
            HStack {
                Text(ingredient.name)
                    .font(.body)
                    .foregroundStyle(Color.Theme.text)
                    .strikethrough(isCompleted)
                Spacer()
                Text(ingredient.formattedAmount)
                    .font(.callout)
                    .bold()
                    .foregroundStyle(Color.Theme.primary)
            }
            .opacity(isCompleted ? 0.4 : 1)
        }
    }

    @ViewBuilder
    func InstructionRow(_ instruction: RecipeDetailsModels.FetchDetails.ViewModel.ActionItem) -> some View {
        let isCompleted = viewState.isCompleted(instruction)
        CookbookCard {
            HStack(alignment: .top, spacing: 16) {
                // A beautiful numbered circle for the step
                Text("\(instruction.stepNumber)")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.Theme.primary)
                    .clipShape(Circle())

                Text(instruction.description)
                    .font(.body)
                    .foregroundStyle(Color.Theme.text)
                    .strikethrough(isCompleted)
                    .padding(.top, 4)

                Spacer(minLength: 0)
            }
            .opacity(isCompleted ? 0.4 : 1)
        }
    }

}

// MARK: - Preview
#Preview {
    @Bindable var router = AppRouter()
    RecipeDetailsModule.biuild(for: 1)
        .environment(router)
}
