//
//  SearchView.swift
//  Chef
//
//  Created by Jason Clemens on 1/22/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI

struct SearchField: View{
    @State private var searchText = ""
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search Recipes by Name", text: $searchText)
                .frame(width: 320, height: 35)
                .background(Color.init( red: 0.9, green: 0.9, blue: 0.9, opacity: 1))
            .cornerRadius(5)
        }
    }
}
    
struct SearchView: View {
    @State private var ingredients = ["Eggs", "Butter", "Cheese"]
    @State private var ingredientTxt = ""
    func deleteIngredient(at indexSet: IndexSet) {
        self.ingredients.remove(atOffsets: indexSet)
    }
    var body: some View {
        VStack {
            SearchField()
            ZStack {
                Image("Eggs-in-a-carton")
                .resizable()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: Alignment.topLeading)
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 10)
                VStack {
                    Spacer()
                    VStack {
                        Text("Ingredient Search")
                            .font(.headline)
                            .padding(.top)
                        List {
                            TextField("Manually enter an ingredient...", text: $ingredientTxt)
                            ForEach(ingredients, id: \.self) { ingredient in
                                Text(ingredient)
                            }.onDelete(perform: self.deleteIngredient)
                        }
                        HStack {
                            Spacer()
                            NavigationLink(destination: ResultsView(searchResults: [Recipe(name: "Baked Denver Omelet", imageURL: URL(string: "https://images.media-allrecipes.com/userphotos/560x315/1029125.jpg"), ingredients: ["2 tablespoons butter", "1/2 onion, chopped", "1/2 green bell pepper, chopped", "1 cup chopped cooked ham", "8 eggs", "1/4 cup milk", "1/2 cup shredded Cheddar cheese", "salt and ground black pepper to taste"], steps: ["Preheat oven to 400 degrees F (200 degrees C). Grease a 10-inch round baking dish.", "Melt butter in a large skillet over medium heat; cook and stir onion and bell pepper until softened, about 5 minutes. Stir in ham and continue cooking until heated through, 5 minutes more.", "Beat eggs and milk in a large bowl. Stir in Cheddar cheese and ham mixture; season with salt and black pepper. Pour mixture into prepared baking dish.", "Bake in preheated oven until eggs are browned and puffy, about 25 minutes. Serve warm."])])) {
                                Text("Search >")
                                    .foregroundColor(Color.blue)
                                    .padding([.leading, .trailing, .bottom])
                            }
                        }
                    }.frame(height: 420).background(BlurCard())
                }.edgesIgnoringSafeArea(.bottom)
            }
        }.navigationBarTitle(Text("Find a Recipe"), displayMode: .inline)
    }
}
    
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
