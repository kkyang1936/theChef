//
//  RecipeView.swift
//  Chef
//
//  Created by KK Yang on 2020/1/22.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI



struct RecipeView: View {
    @State private var recipeName = "Baked Denver Omelet"
    @State private var ingredients = [("butter", "2 tablespoons"), ("onion", "1/2, chopped"), ("green bell pepper", "1/2, chopped"), ("cooked ham", "1 cup, chopped"), ("eggs", "8"), ("milk", "1/4 cup"), ("cheddar cheese", "1/2 cup, shredded"), ("salt and ground black pepper", "to taste")]
    @State private var steps = ["Preheat oven to 400 degrees F (200 degrees C). Grease a 10-inch round baking dish.", "Melt butter in a large skillet over medium heat; cook and stir onion and bell pepper until softened, about 5 minutes. Stir in ham and continue cooking until heated through, 5 minutes more.", "Beat eggs and milk in a large bowl. Stir in Cheddar cheese and ham mixture; season with salt and black pepper. Pour mixture into prepared baking dish.", "Bake in preheated oven until eggs are browned and puffy, about 25 minutes. Serve warm."]
    var body: some View {
        VStack {
            HStack {
                Text(recipeName)
                    .font(.title)
                    .fontWeight(.medium)
                    .offset(x: 20)
                Image("SecondOmelette")
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
                ForEach(0..<ingredients.count) { index in
                    HStack {
                        Text(self.ingredients[index].0)
                        Spacer()
                        Text(self.ingredients[index].1)
                    }
                }
                HStack {
                    Spacer()
                    Text("Steps")
                        .font(.headline)
                    Spacer()
                }
                ForEach(steps, id:\.self) { step in
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
        RecipeView()
    }
}

