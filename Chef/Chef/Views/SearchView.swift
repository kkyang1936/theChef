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
                            NavigationLink(destination: ResultsView()) {
                                Text("Search >")
                                    .foregroundColor(Color.blue)
                                    .padding([.leading, .trailing, .bottom])
                            }
                        }
                    }.frame(height: 420).background(BlurCard())
                }.edgesIgnoringSafeArea(.bottom)
            }
        }.navigationBarTitle("Find a Recipe")
    }
}
    
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
