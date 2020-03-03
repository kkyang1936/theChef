//
//  RecipeSearchScraper.swift
//  Chef
//
//  Created by Aaron Nikolai on 2/17/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import Foundation
import SwiftSoup

class RecipeSearchScraper {
    
    func parseRecipes(ingredients: [String]) -> [RecipePreview] {
        var recipePreviews = [RecipePreview]()
        let recipeSearch = RecipeSearch()
        let searchURL = recipeSearch.getURLWithIngredients(ingredients: ingredients)
        let html = try! String(contentsOf: searchURL, encoding: .utf8)
        do {
            let doc: Document = try SwiftSoup.parse(html)
            let recipeElements =  try doc.select("article.fixed-recipe-card")
            for recipe in recipeElements {
                recipePreviews.append(parseRecipe(recipe: recipe))
            }
        } catch {
            print("Error parsing recipe results")
            return []
        }
        return recipePreviews
    }
    
    private func parseRecipe(recipe: Element) -> RecipePreview {
        var name = String()
        var imageURL = URL(string: "")
        var recipeURL = URL(string: "")
        do {
            name = try recipe.select("a[.data-type*=Recipe]").attr("data-name")
            let imageURLString = try recipe.select("a[.data-type*=Recipe]").attr("data-imageurl")
            imageURL = URL(string: imageURLString)
            let recipeURLString = try recipe.select("div.fixed-recipe-card__info").select("h3").select("a").text()
            recipeURL = URL(string: recipeURLString)
        } catch {
            print("Error parsing recipe title")
        }
        return RecipePreview(name: name, imageURL: imageURL, recipeURL: recipeURL)
    }
}
