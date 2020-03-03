//
//  RecipeSearch.swift
//  Chef
//
//  Created by Aaron Nikolai on 2/17/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import Foundation

//https://www.allrecipes.com/search/results/?wt=recipe%20keywords&ingIncl=apple,banana,cheese&sort=re
//https://www.allrecipes.com/search/results/?ingIncl=apple,banana,cheese&sort=re
//https://www.allrecipes.com/search/results/?wt=recipe%20keywords&sort=re

func createURL(keyword: String = "", ingredients: [String] = []) -> URL {
    var str = "https://www.allrecipes.com/search/results/"
    if (!keyword.isEmpty) {
        str.append("?wt=" + keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
    }
    if (!ingredients.isEmpty) {
        str.append("&ingIncl=")
        str.append(ingredients[0].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        for i in 1...ingredients.count - 1 {
            str.append("," + ingredients[i].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        }
    }
    str.append("&sort=re")
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
