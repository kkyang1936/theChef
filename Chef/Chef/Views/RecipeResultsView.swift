//
//  SearchView.swift
//  Chef
//
//  Created by Jason Clemens on 1/22/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI

struct ResultsView: View {
    @State private var searchResults: [SearchResult] = []
    private var recipeName: String
    private var ingredientList: [String]
    
    init(recipeName: String, ingredientList: [String]) {
        self.recipeName = recipeName
        self.ingredientList = ingredientList
    }
    
    var body: some View {
        List {
            if (searchResults.isEmpty) {
                Text("Loading")
                    .frame(height: 100)
            } else {
                ForEach(searchResults, id: \.self) { result in
                    RecipeResultRow(recipeResult: result)
                }
            }
        }.navigationBarTitle("Recipes", displayMode: .inline)
            .onAppear() {
                DispatchQueue.main.async {
                    self.searchResults = [SearchResult(name: "Baked Denver Omelet", imageURL: URL(string: "https://images.media-allrecipes.com/userphotos/300x300/1029125.jpg"), recipeLink: "https://www.allrecipes.com/recipe/229780/baked-denver-omelet/?internalSource=hub%20recipe&referringContentType=Search")]
                }
        }
    }
}

struct RecipeResultRow: View {
    var recipeResult: SearchResult
    var body: some View {
        NavigationLink(destination: RecipeView(recipe: recipeResult.recipeStruct)) {
            HStack {
                Text(recipeResult.name)
                    .font(.title)
                    .fontWeight(.light)
                    .lineLimit(2)
                Spacer()
                if (recipeResult.imageURL != nil) {
                    NetworkImage(url: recipeResult.imageURL!)
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
        ResultsView(recipeName: "", ingredientList: [])
    }
}
