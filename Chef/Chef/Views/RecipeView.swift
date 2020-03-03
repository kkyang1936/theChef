//
//  RecipeView.swift
//  Chef
//
//  Created by KK Yang on 2020/1/22.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI

struct RecipeView: View {
    var recipe: Recipe
    
    var body: some View {
        VStack {
            HStack {
                Text(recipe.name)
                    .font(.title)
                    .fontWeight(.medium)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                NetworkImage(url: recipe.imageURL!)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                .padding()
            }
            List {
                HStack {
                    Spacer()
                    Text("Ingredients")
                        .font(.headline)
                    Spacer()
                    
                }
                ForEach(recipe.ingredients, id:\.self) { ingredient in
                   Text(ingredient)
                }
                HStack {
                    Spacer()
                    Text("Steps")
                        .font(.headline)
                    Spacer()
                }
                ForEach(recipe.steps, id:\.self) { step in
                    Text(step)
                }
            }
            Button(action: {}) {
                Image("Hat-icon")
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                
            }
        }.navigationBarTitle("View Recipe", displayMode: .inline)
            .onAppear(perform: {
                lastOpenRecipe = self.recipe
            })
    }
    
}



struct ContentView_Preview: PreviewProvider {
    static let sampleRecipe = Recipe(name: "Baked Denver Omelet", imageURL: URL(string: "https://images.media-allrecipes.com/userphotos/560x315/1029125.jpg"), ingredients: ["2 tablespoons butter", "1/2 onion, chopped", "1/2 green bell pepper, chopped", "1 cup chopped cooked ham", "8 eggs", "1/4 cup milk", "1/2 cup shredded Cheddar cheese", "salt and ground black pepper to taste"], steps: ["Preheat oven to 400 degrees F (200 degrees C). Grease a 10-inch round baking dish.", "Melt butter in a large skillet over medium heat; cook and stir onion and bell pepper until softened, about 5 minutes. Stir in ham and continue cooking until heated through, 5 minutes more.", "Beat eggs and milk in a large bowl. Stir in Cheddar cheese and ham mixture; season with salt and black pepper. Pour mixture into prepared baking dish.", "Bake in preheated oven until eggs are browned and puffy, about 25 minutes. Serve warm."])
    static var previews: some View {
        RecipeView(recipe: sampleRecipe)
    }
}

