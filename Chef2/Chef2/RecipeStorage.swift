//
//  RecipeStorage.swift
//  Chef
//
//  Created by Aaron Nikolai on 4/8/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class RecipeStorage: NSManagedObject, Identifiable {
    @NSManaged public var name:String?
    @NSManaged public var imageURL:String?
    @NSManaged public var recipeURL:String?
}

extension RecipeStorage {
       static func getAllRecipes() -> [SearchResult] {
		guard let appDelegate =
		  UIApplication.shared.delegate as? AppDelegate else {
		  return []
		}
		let moc = appDelegate.persistentContainer.viewContext
		var fetched = [NSManagedObject]()
           let fetchRequest =
		   NSFetchRequest<NSManagedObject>(entityName: "RecipeStorage")
           let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
           fetchRequest.sortDescriptors = [sortDescriptor]
		do {
			fetched = try moc.fetch(fetchRequest)
		} catch {
			print("Failed to fetch recipe storage data")
		}
		return batchToRecipePreviewFromNSObject(objects: fetched)
       }
    
	static private func batchToRecipePreviewFromNSObject(objects: [NSManagedObject]) -> [SearchResult] {
		var recipeStorages = [SearchResult]()
        for object in objects {
			let newRecipe = SearchResult(name: object.value(forKeyPath: "name") as! String,
										 imageURL: URL(string: object.value(forKeyPath: "imageURL") as! String),
										  recipeLink: object.value(forKeyPath: "recipeURL") as! String)
        recipeStorages.append(newRecipe)
        }
        return recipeStorages
	}
	
	static func saveRecipe(recipe: SearchResult) {
		guard let appDelegate =
		  UIApplication.shared.delegate as? AppDelegate else {
		  return
		}
		let moc = appDelegate.persistentContainer.viewContext
		
		let entity =
		NSEntityDescription.entity(forEntityName: "RecipeStorage",
								   in: moc)!
		let recipeStorage = NSManagedObject(entity: entity,
		insertInto: moc)
		recipeStorage.setValue(recipe.name, forKeyPath: "name")
		recipeStorage.setValue(recipe.imageURL?.absoluteString, forKeyPath: "imageURL")
		recipeStorage.setValue(recipe.recipeLink, forKeyPath: "recipeURL")
		do {
		  try moc.save()
		} catch let error as NSError {
		  print("Could not save. \(error), \(error.userInfo)")
		}
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
