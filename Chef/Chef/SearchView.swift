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
            TextField("Search Recipes", text: $searchText)
                .frame(width: 320, height: 35)
                .background(Color.init( red: 0.9, green: 0.9, blue: 0.9, opacity: 1))
            .cornerRadius(5)
        }
    }
}

struct SearchView: View {
    var body: some View {
        VStack {
            SearchField()
            Image("Eggs-in-a-carton")
            .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 0)
            List {
                Text("Hello World")
                Text("1")
                Text("2")
                Text("3")
                Text("4")
                Text("5")
                Text("6")
                Text("7")
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
