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
    @State private var ingredients = ["Eggs", "Other"]
    @State private var ingredientTxt = ""
    var body: some View {
        VStack {
            SearchField()
            Image("Eggs-in-a-carton")
            .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 0)
            Text("Ingredient Search")
                .font(.headline)
            List {
                HStack {
                    TextField("Manually enter an ingredient...", text: $ingredientTxt)
                    Image(systemName: "add")
                }
                ForEach(ingredients, id: \.self) { ingredient in
                    Text(ingredient)
                }.onDelete(perform: self.delete)
            }
            HStack {
                Spacer()
                Button(action: {}) {
                    Text("Search")
                }
            }
        }
    }
    func delete(at indexSet: IndexSet) {
        self.ingredients.remove(atOffsets: indexSet)
    }

    
}
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
