//
//  Recipes.swift
//  Davids Grindz
//
//  Created by Steven Lipton on 3/23/25.
//

import Foundation

/// The Parent Item of a recipe
/// - parameter id:**Primary Key**  unique identifier of the recipe
/// - parameter name: The common name of the food or prep item made
/// - parameter yield: the amout of the food item made
/// - parameter uom: The unit of measure for the food item `yield`
/// - parameter category: The category of the food. Useful for organizing purposes.
struct Recipe:Identifiable,Hashable,Equatable{
    var id:Int
    var name:String
    var yield:Double
    var uom:UnitOfMeasure
    var category:IngredientCategory
    
    static var blank:Recipe{
        Recipe(id: -1, name: "", yield: 0, uom: .na, category: .na)
    }
}


@Observable
class Recipes{
    var table:[Recipe]
    init(){
        self.table = []
        preload()
    }
    
    
//----- Add Methods
    
    /// Find the next ID available for a recipe
    /// - Returns one greater than the largest ID
    var nextID:Int{
        if let last = table.max(by:{$0.id < $1.id}){
            return last.id + 1
        } else {
            return 0
        }
    }
    
    /// Add an recipe
    /// - Parameter a complete `Recipe` object
    @discardableResult
    func addRecipe(recipe:Recipe) -> Recipe {
        var newRecipe = recipe
        newRecipe.id = nextID
        table.append(newRecipe)
        return newRecipe
    }
    
    /// Add an recipe by the properties of `recipe`
    @discardableResult
    func addRecipe(id:Int! = nil, name:String,yield:Double, uom:UnitOfMeasure! = nil,category:IngredientCategory = .pizza) -> Recipe {
        var newID:Int
        if let id = id{
            // use the given id
            newID = id
        } else {
            // find the next id. If not found it is zero
            newID = nextID
        }
        //add the recipe
        let newRecipe = Recipe(id: newID, name: name, yield: yield, uom: uom, category: category)
        table.append(newRecipe)
        return newRecipe
    }
    
// ----- Delete methods
    
    ///Delete based on an `id`
    func removeRecipe(id:Int){
        // find the index of the item with id, and remove from that index.
        if let index = table.firstIndex(where: {$0.id == id}){
            table.remove(at: index)
        }
    }

    
//----- Update methods
    
    /// Update based on a `recipe`
    @discardableResult
    func updateRecipe(recipe:Recipe) -> Recipe? {
        //find the index of that id, and replace the element at that index.
        if let index = table.firstIndex(where: {$0.id == recipe.id}){
            table[index] = recipe
            return recipe
        }
        return nil
    }
    
//----- Find methods
    
    ///Find an recipe by its `id`
    func recipe(id:Int)->Recipe!{
        table.first{$0.id == id}
    }
    
    ///Filter to recipies for a category
    func recipes(category:IngredientCategory)->[Recipe]{
        table.filter({$0.category == category})
    }
    
    
//----- Navigation Methods
    
    ///Find the next recipe in the sequence of recipes by `id`
    func nextRecipe(id:Int)->Recipe{
        if let index = table.firstIndex(where:{$0.id == id}){
            let newIndex = (index + 1) % table.count
            return table[newIndex]
        }
        var notFound:Recipe = .blank
        notFound.name = "Not found"
        return notFound
    }
    
    ///Find the previous recipe in the sequence of recipes by `id`
    func previousRecipe(id:Int)->Recipe{
        if let index = table.firstIndex(where:{$0.id == id}){
            if index != 0{
                let newIndex = (index - 1)
                return table[newIndex]
            } else {
                return table[table.count - 1]
            }
        }
        var notFound:Recipe = .blank
        notFound.name = "Not found"
        return notFound
    }
    
// --- Test items
    
    /// Data to preload into the system for testing and making some yummy pizzas
    func preload(){
        self.addRecipe(id: 01, name: "Standard Pizza Dough", yield: 1500, uom: .gram, category: .refPrep)
        self.addRecipe(id: 02, name: "Neopolitan Pizza Dough", yield:2000,uom:.gram,category: .refPrep)
        self.addRecipe(id: 03, name: "Huli Chicken Pizza", yield: 1, uom: .each)
        self.addRecipe(id: 04, name: "Margherita Pizza", yield: 1, uom: .each)
        self.addRecipe(id: 05, name: "Hawaiian Pizza",yield: 1,uom: .each)
    }
}


