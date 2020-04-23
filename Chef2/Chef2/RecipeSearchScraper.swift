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
    
    func parseRecipes(keyword: String, ingredients: [String]) -> [SearchResult] {
        var recipePreviews = [SearchResult]()
        let searchURL = createURL(keyword: keyword, ingredients: ingredients)
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
    
    private func parseRecipe(recipe: Element) -> SearchResult {
        /*var name = ""
        var imageURL: URL? = nil
        var recipeURL = ""
        do {
            recipeURL = try recipe.select("a[.data-type*=Recipe]").attr("data-name")
            let imageURLString = try recipe.select("a[.data-type*=Recipe]").attr("data-imageurl")
            imageURL = URL(string: imageURLString)
            name = try recipe.select("div.fixed-recipe-card__info").select("h3").select("a").text()
            
        } catch {
            print("Error parsing recipe title")
        }
        print(name, imageURL, recipeURL)
        */
        var name: String = ""
        var imageURL: String = ""
        var recipeURL: String = ""
        do {
            name = try recipe.select("div h3 a span").first()!.text()
            imageURL = try recipe.select("div a img").first()!.attr("data-original-src")
            recipeURL = try recipe.select("div a").first()!.attr("href")
        } catch {
            print("Unable to parse article fixed-recipe-card")
        }
        //print("name: ", name, ", imageURL: ", imageURL, ", recipeURL: ", recipeURL)
        return SearchResult(name: name, imageURL: URL(string: imageURL)!, recipeLink: recipeURL)
    }
}
