//
//  IngredientCategory.swift
//  Davids Grindz
//
//  Created by Steven Lipton on 3/23/25.
//

import Foundation
/// A list of food categories, including raw ingredients, prepeerd items and finished dishes.
enum IngredientCategory:String,CaseIterable{
    case spices = "Spices"
    case dry = "Dry Ingredients"
    case liquid = "Liquid Ingredients"
    case produce = "Produce"
    case meat = "Meat"
    case dairy = "Dairy"
    case cheese = "Cheese"
    case refrigerated = "Other refrigerated"
    case beverage = "Beverage"
    case other = "Other non-refrigerated"
    case refPrep = "Refrigerated Prep Items"
    case prep = "Prep Item"
    case pizza = "Pizza"
    case na = "N/A"
    
/// Find a default unit of measure for an ingredient category
    var uom:UnitOfMeasure{
        switch self{
        case .liquid,.dairy,.beverage :return .liter
        case .cheese,.dry,.refPrep,.prep :return .gram
        case .produce,.meat,.other,.refrigerated,.pizza :return .each
        default :return .na
        }
    }
///  a list of prepped categories for categorizing the menu. 
    var preppedCategories:[IngredientCategory]{[.refPrep,.prep,.pizza,.beverage]}
    
    
}
