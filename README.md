# Cookbook

Capstone project for the course **Complete Guide to SwiftUI**, formerly known as **SwiftUI Complete Training**. The previous course name explains the `SwiftUICT` abbreviation used in the project naming.

## Project Overview

Cookbook is a SwiftUI app built as the course capstone assignment. The app presents a collection of recipes and lets users navigate from the recipe list into detailed recipe information.

The main task was to build a Cookbook app that includes:

- A recipe list screen
- Recipe details screen
- Ingredients for each recipe
- Step-by-step cooking instructions
- SplitView-based navigation

For fun, an animated `SplashScreen` was also added before the main app flow.

## Course-Provided Model

The base domain model was declared by the course materials. These files are marked by **Davids Grindz** and include the core recipe data structures, such as:

- `Recipes`
- `Ingredients`
- `RecipeSteps`
- Supporting enumerations and model types

The app implementation builds on top of these course-provided models.

## Architecture

The project is implemented using **Clean Architecture** with a **CleanSwift (VIP)** presentation layer.

The code is organized around clear boundaries between app infrastructure, domain models, data access, and feature scenes.

### Layers

- `App`: Application entry point, dependency injection, and routing
- `Core`: Shared data access, repository protocols, style guide, and reusable UI components
- `Models`: Recipe domain models, enumerations, and errors
- `Scenes`: Feature modules using the CleanSwift VIP structure
- `Tests`: Unit, presenter, interactor, repository, router, and SwiftUI hosting tests

### Scene Structure

Each main feature scene follows the VIP pattern:

- `Interactor`: Coordinates business logic and data access
- `Presenter`: Converts responses into view state
- `View`: Renders SwiftUI UI and sends user actions
- `Models`: Defines request, response, and view model types
- `Protocols`: Defines scene contracts
- `Module`: Assembles scene dependencies

Implemented scenes include:

- `RecipeList`
- `RecipeDetails`
- `SplashScreenView`

## Testing Approach

The project was developed under **BDD/ATDD principles**, with tests covering the expected behavior of the main app layers.

Test coverage includes:

- Repository behavior
- Recipe model behavior
- Recipe list interactor and presenter behavior
- Recipe details interactor and presenter behavior
- App router behavior
- SwiftUI hosting tests for major views

The test plan is located at:

```text
Cookbook/CookbookTests/CookBook.xctestplan
```

## Project Structure

```text
Cookbook/
  Cookbook/
    App/
    Core/
    Models/
    Scenes/
    Assets.xcassets
  CookbookTests/
    App/
    Interactors/
    Models/
    Presenters/
    Views/
    CookBook.xctestplan
```

## Notes

This project demonstrates a SwiftUI implementation that combines course-provided recipe models with a structured app architecture, SplitView navigation, reusable styling, and behavior-focused tests.
