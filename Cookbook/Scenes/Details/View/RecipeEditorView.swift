//
//  RecipeEditorView.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by OpenAI on 14.08.2026.
//

import SwiftUI

/// A form screen for creating or editing recipe metadata.
struct RecipeEditorView: View {
    let recipeID: Int?
    let interactor: RecipeDetailsBusinessLogic
    @State var viewState: RecipeDetailsModels.ViewState

    @Environment(\.dismiss) private var dismiss

    private var isNewRecipe: Bool {
        recipeID == nil
    }

    private var navigationTitle: String {
        isNewRecipe ? "New Recipe" : "Edit Recipe"
    }

    var body: some View {
        @Bindable var viewState = viewState

        Form {
            Section("Recipe") {
                TextField("Name", text: $viewState.editableRecipe.name)
                    .textInputAutocapitalization(.words)

                TextField("Yield", text: $viewState.editableRecipe.yieldText)
                    .keyboardType(.decimalPad)
            }

            Section("Details") {
                Picker("Unit", selection: $viewState.editableRecipe.unitOfMeasure) {
                    ForEach(UnitOfMeasure.allCases, id: \.self) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }

                Picker("Category", selection: $viewState.editableRecipe.category) {
                    ForEach(IngredientCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.Theme.background)
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveRecipe()
                }
                .disabled(viewState.editableRecipe.recipe == .blank || viewState.isSaving)
            }
        }
        .task {
            await loadRecipeIfNeeded()
        }
        .onChange(of: viewState.didSaveRecipe) { _, didSaveRecipe in
            guard didSaveRecipe else { return }
            dismiss()
        }
    }
}

// MARK: - Actions

private extension RecipeEditorView {
    func loadRecipeIfNeeded() async {
        guard let recipeID else {
            viewState.displayEditableRecipe(viewModel: .blank)
            return
        }

        await interactor.fetchRecipe(request: .init(recipeID: recipeID))
    }

    func saveRecipe() {
        let recipe = viewState.editableRecipe.recipe
        guard recipe != .blank else { return }

        viewState.isSaving = true
        Task {
            await interactor.saveRecipe(
                request: .init(
                    recipe: recipe,
                    isNewRecipe: isNewRecipe
                )
            )
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        RecipeDetailsModule.buildEditor(for: nil)
    }
}
