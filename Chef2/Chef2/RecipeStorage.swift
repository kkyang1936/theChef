//
//  RecipeStorage.swift
//  Chef
//
//  Created by Aaron Nikolai on 4/8/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import Foundation
import CoreData

public class RecipeStorage: NSManagedObject, Identifiable {
    @NSManaged public var name:String?
    @NSManaged public var imageURL:String?
    @NSManaged public var recipeURL:String?
    
}

extension RecipeStorage {
       static func getAllRecipes() -> NSFetchRequest<RecipeStorage> {
           let request:NSFetchRequest<RecipeStorage> = RecipeStorage.fetchRequest() as!
               NSFetchRequest<RecipeStorage>
           
           let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
           
           request.sortDescriptors = [sortDescriptor]
        
            return request
       }
    
    private func toRecipePreview() -> SearchResult {
        return SearchResult(name: name!, imageURL: URL(string: imageURL!), recipeLink: recipeURL!)
    }
    
    static func batchToRecipePreview(recipeStorage: [RecipeStorage]) -> [SearchResult] {
        var recipeHistory = [SearchResult]()
        for recipe in recipeStorage {
        recipeHistory.append(recipe.toRecipePreview())
        }
        return recipeHistory
    }
    
    static func temporaryHistoryCells() -> [SearchResult] {
        let recipeSearchScraper = RecipeSearchScraper()
        return recipeSearchScraper.parseRecipes(keyword: "",ingredients: ["bacon","eggs","cheese"])
    }
}
