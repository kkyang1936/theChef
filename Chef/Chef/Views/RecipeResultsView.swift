//
//  SearchView.swift
//  Chef
//
//  Created by Jason Clemens on 1/22/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI
import UIKit

struct ResultsView: View {
    @State private var searchResults: [SearchResult] = []
    private var recipeName: String
    private var ingredientList: [String]
    @State private var noResults = false;
    
    init(recipeName: String, ingredientList: [String]) {
        self.recipeName = recipeName
        self.ingredientList = ingredientList
    }
    
    var body: some View {
        List {
            if (searchResults.isEmpty) {
                HStack {
                    Spacer()
                    if (self.noResults) {
                        Text("No recipes found")
                            .frame(height: 100)
                    } else {
                        LoadingView(style: .large)
                        .frame(height: 100)
                    }
                    Spacer()
                }
            } else {
                ForEach(searchResults, id: \.self) { result in
                    RecipeResultRow(recipeResult: result)
                }
            }
        }.navigationBarTitle("Recipes", displayMode: .inline)
            .onAppear() {
                DispatchQueue.main.async {
                    self.searchResults = getSearchResults(keyword: self.recipeName, ingredients: self.ingredientList)
                    self.noResults = self.searchResults.isEmpty
                }
        }
    }
}

struct RecipeResultRow: View {
    var recipeResult: SearchResult
    var body: some View {
        NavigationLink(destination: RecipeView(result: recipeResult)) {
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
                    Image("recipe-default-image")
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
        ResultsView(recipeName: "Omelet", ingredientList: ["Egg", "Cheese", "Onion"])
    }
}

struct LoadingView: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style
    func makeUIView(context: UIViewRepresentableContext<LoadingView>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: style)
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingView>) {
        uiView.startAnimating()
    }
}
