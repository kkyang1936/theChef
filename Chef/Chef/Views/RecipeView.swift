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
                    .offset(x: 20)
                Image(recipe.imageName)
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            }
            List {
                HStack {
                    Spacer()
                    Text("Ingredients")
                        .font(.headline)
                    Spacer()
                    
                }
                ForEach(0..<recipe.ingredients.count) { index in
                    HStack {
                        Text(self.recipe.ingredients[index])
                        Spacer()
                        Text(self.recipe.ingredientAmounts[index])
                    }
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
        }.navigationBarTitle("View Recipe")
    }
    
}



struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        RecipeView(recipe: Recipe(name: "Baked Denver Omelet", imageName: "SecondOmelette", ingredients: ["butter", "onion", "green bell pepper", "cooked ham", "eggs", "milk", "cheddar cheese", "salt and ground black pepper"], ingredientAmounts: ["2 tablespoons", "1/2, chopped", "1/2, chopped", "1 cup, chopped", "8", "1/4 cup", "1/2 cup, shredded", "to taste"], steps: ["Preheat oven to 400 degrees F (200 degrees C). Grease a 10-inch round baking dish.", "Melt butter in a large skillet over medium heat; cook and stir onion and bell pepper until softened, about 5 minutes. Stir in ham and continue cooking until heated through, 5 minutes more.", "Beat eggs and milk in a large bowl. Stir in Cheddar cheese and ham mixture; season with salt and black pepper. Pour mixture into prepared baking dish.", "Bake in preheated oven until eggs are browned and puffy, about 25 minutes. Serve warm."]))
    }
}

