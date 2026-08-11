//
//  Ingredients.swift
//  Davids Grindz
//
//  Created by Steven Lipton on 3/23/25.
//

import Foundation

///A single ingredient or Food item.
/// - Parameter id: **Primary Key** the internal identifier of the recipe
/// - Parameter itemName: Common name for the food item
/// - Parameter uom: the unit of measure for this food item
/// - Parameter category: the catorgy  for this food item. used for grouping and sorting
struct Ingredient:Identifiable,Hashable,Equatable{
    var id:Int
    var itemName:String
    var uom:UnitOfMeasure
    var category:IngredientCategory = .na
    
    static var blank:Ingredient{Ingredient(id: 0, itemName: "", uom: .na, category: .na)}
}

/// the list of all ingredients available
@Observable
class Ingredients{
    var ingredientID:Int
    var table:[Ingredient]
    
    init(){
        //Add action entry
        ingredientID = 0
        table = [Ingredient(id: 0, itemName: "", uom: .na)]
        preloadData()
    }
    
    ///A blank Ingredient for initialization, alternative to a plain `init()` to keep consistent with other models here
    static let blank = Ingredient(id: -1, itemName: "", uom: .na, category: .na)
    
    
    
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
    
    
    /// Add an ingredient with an `Ingredient`
    func addIngredient(ingredient:Ingredient){
        var newIngredient = ingredient
        newIngredient.id = nextID
        table.append(newIngredient)
    }
    
    /// Add an ingredient by the properties of `Ingredient`
    /// Useful for the preloading stage.
    func addIngredient(name:String,category:IngredientCategory, uom:UnitOfMeasure! = nil){
        // find the unit of measure. default to category basis if nil
        let itemUom =  uom ?? category.uom
        // find the next id. if not found it is zero
        let id = nextID
        //add the ingredient
        let newIngredient = Ingredient(id: id, itemName: name, uom: itemUom, category: category)
        table.append(newIngredient)
    }
    
//----- Delete methods
    
    ///Delete based on an `id`
    func removeIngredient(id:Int){
        // find the index of the item with id, and remove from that index.
        if let index = table.firstIndex(where: {$0.id == id}){
            table.remove(at: index)
        }
    }
    

    
//----- Update methods
    
    /// Update based on a `Ingredient`
    func updateIngredient(ingredient:Ingredient){
        //find the index of that id, and replace the element at that index.
        if let index = table.firstIndex(where: {$0.id == ingredient.id}){
            table[index] = ingredient
        }
    }
    
//----- Find methods
    
    ///Find an ingredient by its `id`
    func ingredient(id:Int)->Ingredient!{
        table.first{$0.id == id}
    }
    
//----- preloading and testing data
    
    /// Data to preload into the system for testing and making some yummy pizzas
    func preloadData(){
        addIngredient(name: "Flour", category: .dry)
        addIngredient(name: "Water", category:.liquid)
        addIngredient(name:"Active dry yeast", category:.refrigerated, uom:.gram)
        addIngredient(name: "Granulated Sugar", category: .dry)
        addIngredient(name: "Parmesean Cheese", category: .cheese)
        addIngredient(name: "Salt", category: .spices,uom: .gram)
        addIngredient(name: "Olive Oil", category: .liquid, uom: .gram)
        addIngredient(name: "Huli Huli Chicken", category: .meat,uom:.gram)
        addIngredient(name: "Onions", category: .produce, uom:.gram)
        addIngredient(name: "Grated Ginger", category: .produce, uom:.gram)
        addIngredient(name: "Crushed Macadamia Nuts", category: .dry)
        addIngredient(name: "Tomato sauce", category: .refPrep, uom:.mililiter)
        addIngredient(name: "Mozzarella Cheese", category: .cheese)
        addIngredient(name: "Fresh(Buffalo) Mozzarella", category: .cheese)
        addIngredient(name: "Basil Leaves", category: .produce)
        addIngredient(name: "Crushed Tomatoes", category: .dry)
        addIngredient(name:  "Fresh Tomatoes", category: .produce)
        addIngredient(name: "SPAM", category: .other, uom:.each)
        addIngredient(name: "Bean Sprouts", category: .produce, uom:.gram)
        addIngredient(name: "Pineapple", category: .produce, uom:.gram)
        addIngredient(name: "Low Moisture Mozzarella", category: .cheese)
        addIngredient(name: "Huli Huli Chicken Sauce", category: .dry)
        addIngredient(name: "White rice", category: .dry)
        addIngredient(name: "FuriKake", category: .spices,uom:.gram)
        addIngredient(name: "Nori", category: .dry)
        addIngredient(name: "Purple Sweet Potato(Ube)", category: .produce)
        addIngredient(name: "Asiago", category: .cheese)
        addIngredient(name: "Gorgonzola", category: .cheese)
        addIngredient(name: "Sausage", category: .meat)
        addIngredient(name: "Lava Sauce", category: .refPrep)
        addIngredient(name: "Button Mushroom", category: .produce)
        addIngredient(name: "Japanese Mushroom Mix", category: .produce)
        addIngredient(name: "Lilikoi", category: .produce)
        addIngredient(name: "Pepperoni", category: .meat)
        addIngredient(name: "Chicken breasts", category: .meat)
        addIngredient(name: "BBQ sauce", category: .refPrep, uom:.mililiter)
        addIngredient(name: "POG", category: .beverage)
        addIngredient(name: "SweetPizza Dough", category: .prep,uom: .gram)
        addIngredient(name: "Neopolitan Pizza Dough", category: .prep,uom:.gram)
        addIngredient(name: "New York Pizza Dough", category: .prep,uom:.gram)
       
    }
}

