//
//  HistoryView.swift
//  Chef
//
//  Created by Aaron Nikolai on 4/8/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    @State private var recipeResults = [SearchResult]()
    
    var body: some View {
        List {
			if (recipeResults.count > 0) {
				ForEach(recipeResults, id: \.self) { result in
					RecipeResultRow(recipeResult: result)
				}
			} else {
				HStack {
					Spacer()
					Text("No recipe history.")
                    .font(.title)
                    .fontWeight(.light)
                    .lineLimit(2)
					Spacer()
				}
			}
        }.navigationBarTitle("History", displayMode: .inline)
            .onAppear() {
                DispatchQueue.main.async {
					self.recipeResults = RecipeStorage.getAllRecipes()
                }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
