//
//  RecipeSearch.swift
//  Chef
//
//  Created by Aaron Nikolai on 2/17/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import Foundation

class RecipeSearch {
    private let baseURL = "https://www.allrecipes.com/search/results/?ingIncl="
    private var finalURL = URL(string: "")
    
    private func createURL(ingredients: [String]) -> URL {
        var stringURL = String()
        stringURL.append(baseURL)
        stringURL.append(ingredients.joined(separator: ","))
        stringURL.append("&sort=re")
        return URL(string: stringURL)!
    }
    
    func getURLWithIngredients(ingredients: [String]) -> URL {
        return createURL(ingredients: ingredients)
    }
    
    func getRecipesWithIngredients(ingredients: [String]) -> [RecipePreview] {
        let recipeSearchScraper = RecipeSearchScraper()
        return recipeSearchScraper.parseRecipes(ingredients: ingredients)
    }
}
