//
//  HistoryView.swift
//  Chef
//
//  Created by Aaron Nikolai on 4/8/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI

struct HistoryView: View {
    /*
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(fetchRequest: RecipeStorage.getAllRecipes()) private var recipeStorage:FetchedResults<RecipeStorage>
 */
    @State private var recipeResults = [SearchResult]()
    
    var body: some View {
        List {
            ForEach(recipeResults, id: \.self) { result in
                RecipeResultRow(recipeResult: result)
            }
        }.navigationBarTitle("History", displayMode: .inline)
            .onAppear() {
                DispatchQueue.main.async {
                    self.recipeResults = RecipeStorage.temporaryHistoryCells()
                }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
