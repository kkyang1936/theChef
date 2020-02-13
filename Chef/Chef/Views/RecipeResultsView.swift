//
//  SearchView.swift
//  Chef
//
//  Created by Jason Clemens on 1/22/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI

struct ResultsView: View {
    var body: some View {
        List {
                HStack() {
                    NavigationLink(destination: RecipeView(recipe
                        : Recipe(name: "Baked Denver Omelet", imageURL: URL(string: "https://images.media-allrecipes.com/userphotos/560x315/1029125.jpg"), ingredients: ["2 tablespoons butter", "1/2 onion, chopped", "1/2 green bell pepper, chopped", "1 cup chopped cooked ham", "8 eggs", "1/4 cup milk", "1/2 cup shredded Cheddar cheese", "salt and ground black pepper to taste"], steps: ["Preheat oven to 400 degrees F (200 degrees C). Grease a 10-inch round baking dish.", "Melt butter in a large skillet over medium heat; cook and stir onion and bell pepper until softened, about 5 minutes. Stir in ham and continue cooking until heated through, 5 minutes more.", "Beat eggs and milk in a large bowl. Stir in Cheddar cheese and ham mixture; season with salt and black pepper. Pour mixture into prepared baking dish.", "Bake in preheated oven until eggs are browned and puffy, about 25 minutes. Serve warm."]))) {
                        Text("Omelette")
                            .font(.largeTitle)
                        .fontWeight(.light)
                    }.padding()
                    Spacer()
                    Image("omelette")
                        .resizable()
                        .clipShape(Circle())
                        .multilineTextAlignment(.trailing)
                        .frame(width:100, height: 100)
                }
                HStack() {
                    NavigationLink(destination: ContentView()) {
                        Text("Eggs Benedict")
                            .font(.largeTitle)
                        .fontWeight(.light)
                        }
                        .isDetailLink(false)
                        .padding()
                    Spacer()
                    Image("eggs_benedict")
                        .resizable()
                        .clipShape(Circle())
                        .multilineTextAlignment(.trailing)
                        .frame(width:100, height: 100)
                }
                HStack() {
                    NavigationLink(destination: ContentView()) {
                        Text("Scrambled Eggs")
                            .font(.largeTitle)
                        .fontWeight(.light)
                    }.padding()
                    Spacer()
                    Image("scrambled_eggs")
                        .resizable()
                        .clipShape(Circle())
                        .multilineTextAlignment(.trailing)
                        .frame(width:100, height: 100)
                }
            }.navigationBarTitle("Recipes")
            
    }
}


struct ResultsView_Preview: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
