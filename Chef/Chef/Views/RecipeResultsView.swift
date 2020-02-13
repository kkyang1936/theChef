//
//  SearchView.swift
//  Chef
//
//  Created by Jason Clemens on 1/22/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI

struct ResultsView: View {
    @State var searchResults: [Recipe]
    
    var body: some View {
        List {
            ForEach(searchResults, id: \.self) { result in
                RecipeResultRow(recipe: result)
            }
        }.navigationBarTitle("Recipes", displayMode: .inline)
            
    }
}

struct RecipeResultRow: View {
    var recipe: Recipe
    var body: some View {
        NavigationLink(destination: RecipeView(recipe: recipe)) {
            HStack {
                Text(recipe.name)
                    .font(.title)
                    .fontWeight(.light)
                    .lineLimit(2)
                Spacer()
                if (recipe.imageURL != nil) {
                    NetworkImage(url: recipe.imageURL!)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Image("recipe-image-default")
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 5.0)
        }
    }
}

struct ResultsView_Preview: PreviewProvider {
    static var previews: some View {
        ResultsView(searchResults: [Recipe(name: "Baked Denver Omelet", imageURL: URL(string: "https://images.media-allrecipes.com/userphotos/560x315/1029125.jpg"), ingredients: ["2 tablespoons butter", "1/2 onion, chopped", "1/2 green bell pepper, chopped", "1 cup chopped cooked ham", "8 eggs", "1/4 cup milk", "1/2 cup shredded Cheddar cheese", "salt and ground black pepper to taste"], steps: ["Preheat oven to 400 degrees F (200 degrees C). Grease a 10-inch round baking dish.", "Melt butter in a large skillet over medium heat; cook and stir onion and bell pepper until softened, about 5 minutes. Stir in ham and continue cooking until heated through, 5 minutes more.", "Beat eggs and milk in a large bowl. Stir in Cheddar cheese and ham mixture; season with salt and black pepper. Pour mixture into prepared baking dish.", "Bake in preheated oven until eggs are browned and puffy, about 25 minutes. Serve warm."])])
    }
}
