//
//  RecipeView.swift
//  Chef
//
//  Created by KK Yang on 2020/1/22.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI

struct RecipeView: View {
    @State private var recipe: Recipe? = nil
    private var res: SearchResult
    
    init(result: SearchResult) {
        self.res = result
    }
    
    var body: some View {
        VStack {
            if (recipe == nil) {
                LoadingView(style: .large)
            }
            else {
            HStack {
                Text(recipe!.name)
                    .font(.title)
                    .fontWeight(.medium)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 100)
                    .padding(.leading)
                if (recipe!.imageURL == nil) {
                    Image("recipe-default-image")
                    .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()
                } else {
                    NetworkImage(url: recipe!.imageURL!)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                    .padding()
                }
            }
            List {
                HStack {
                    Spacer()
                    Text("Ingredients")
                        .font(.headline)
                    Spacer()
                    
                }
                ForEach(recipe!.ingredients, id:\.self) { ingredient in
                   Text(ingredient)
                }
                HStack {
                    Spacer()
                    Text("Steps")
                        .font(.headline)
                    Spacer()
                }
                ForEach(recipe!.steps, id:\.self) { step in
                    Text(step)
                }
            }
            Button(action: {}) {
                Image("Hat-icon")
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                
            }
            }
        }.navigationBarTitle("View Recipe", displayMode: .inline)
            .onAppear(perform: {
                DispatchQueue.main.async {
                    self.recipe = self.res.recipeStruct
                    lastOpenRecipe = self.recipe
                }
            })
    }
    
}



struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        RecipeView(result: SearchResult(name: "Baked Denver Omelet", imageURL: URL(string: "https://images.media-allrecipes.com/userphotos/560x315/1029125.jpg"), recipeLink: "https://www.allrecipes.com/recipe/229780/baked-denver-omelet/"))
    }
}

