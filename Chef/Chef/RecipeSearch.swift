//
//  RecipeSearch.swift
//  Chef
//
//  Created by Aaron Nikolai on 2/17/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import Foundation

func createURL(keyword: String = "", ingredients: [String] = []) -> URL {
    var str = "https://www.allrecipes.com/search/results/"
    if (!keyword.isEmpty) {
        str.append("?wt=" + keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
    } else {
        str.append("?wt=" + ingredients[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
    }
    if (!ingredients.isEmpty) {
        str.append("&ingIncl=")
        str.append(ingredients[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        if (ingredients.count > 1) {
            for i in 1...ingredients.count - 1 {
                str.append("," + ingredients[i].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            }
        }
    }
    str.append("&sort=re")
    print(str)
    return URL(string: str)!
}

func getSearchResults(keyword: String = "", ingredients: [String] = []) -> [SearchResult] {
    if (keyword == "" && ingredients == []) {
        return []
    }
    return RecipeSearchScraper().parseRecipes(keyword: keyword, ingredients: ingredients)
}

func giveRandomRecipe(keyword: String = "", ingredients: [String] = []) -> Recipe {
    if (keyword == "" && ingredients == []) {
        return Recipe(name: "", imageURL: nil, ingredients: [""], steps: [""])
    }
    return RecipeSearchScraper().parseRecipes(keyword: keyword, ingredients: ingredients).randomElement()!.recipeStruct
}
