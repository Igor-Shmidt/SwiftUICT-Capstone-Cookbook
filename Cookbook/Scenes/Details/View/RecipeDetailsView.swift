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

        // MARK: - Display Logic

        func displayDetails(viewModel: RecipeDetailsModels.FetchDetails.ViewModel) {
            self.viewModel = viewModel
            self.isLoading = false
        }
    }
}

/// The view displaying the full details, ingredients, and instructions for a recipe.
struct RecipeDetailsView: View {
    
    let recipeID: Int
    let interactor: RecipeDetailsBusinessLogic
    @State var viewState: RecipeDetailsModels.ViewState
    
    var body: some View {
        ZStack {
            Color.Theme.background.ignoresSafeArea()
            
            if viewState.isLoading {
                ProgressView("Warming up the oven...")
            } else if let viewModel = viewState.viewModel {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        headerSection(viewModel: viewModel)
                        ingredientsSection(ingredients: viewModel.ingredients)
                        instructionsSection(instructions: viewModel.instructions)
                    }
                    .padding()
                }.scrollIndicators(.never)
            } else {
                EmptyStateView(icon: "exclamationmark.triangle", message: "Failed to load recipe.")
            }
        }
        // Native SwiftUI task modifier triggers the VIP cycle
        .task {
            let request = RecipeDetailsBusinessLogic.Request(recipeID: recipeID)
            await interactor.fetchDetails(request: request)
        }
    }
    
    // MARK: - UI Components
    
    @ViewBuilder
    private func headerSection(viewModel: RecipeDetailsModels.FetchDetails.ViewModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.title)
                .font(.system(.largeTitle, design: .serif))
                .bold()
                .foregroundStyle(Color.Theme.text)
            
            HStack {
                CategoryTag(text: viewModel.categoryName)
                Spacer()
                Text(viewModel.formattedYield)
                    .font(.subheadline)
                    .foregroundStyle(Color.Theme.secondaryText)
            }
        }
    }
    
    @ViewBuilder
    private func ingredientsSection(ingredients: [RecipeDetailsModels.FetchDetails.ViewModel.IngredientItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients")
                .font(.title2)
                .bold()
                .foregroundStyle(Color.Theme.text)
            
            LazyVStack(spacing: 8) {
                ForEach(ingredients) { ingredient in
                    CookbookCard {
                        HStack {
                            Text(ingredient.name)
                                .font(.body)
                                .foregroundStyle(Color.Theme.text)
                            Spacer()
                            Text(ingredient.formattedAmount)
                                .font(.callout)
                                .bold()
                                .foregroundStyle(Color.Theme.primary)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func instructionsSection(instructions: [RecipeDetailsModels.FetchDetails.ViewModel.ActionItem]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Instructions")
                .font(.title2)
                .bold()
                .foregroundStyle(Color.Theme.text)
            
            LazyVStack(spacing: 16) {
                ForEach(instructions) { instruction in
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
                            .padding(.top, 4)
                        
                        Spacer(minLength: 0)
                    }
                    // Using our custom Liquid Glass modifier for steps
                    .padding()
                    .liquidGlass(cornerRadius: 12)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    RecipeDetailsModule.biuild(for: 1)
}
