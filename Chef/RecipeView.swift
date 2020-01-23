//
//  RecipeView.swift
//  Chef
//
//  Created by KK Yang on 2020/1/22.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI



struct RecipeView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Baked Denver Omelet")
                    .font(.title)
                    .fontWeight(.medium)
                    .offset(x: 20)
                Image("SecondOmelette")
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            }
            List {
                HStack {
                    Spacer()
                    Text("Ingredients")
                        .font(.headline)
                    Spacer()
                    
                }
                    HStack {
                        Text("butter")
                        Spacer()
                        Text("2 tablespoons")
                    }
                    HStack {
                        Text("onion")
                        Spacer()
                        Text("1/2, chopped")
                    }
                    HStack {
                        Text("green bell pepper")
                        Spacer()
                        Text("1/2, chopped")
                    }
                    HStack {
                        Text("cooked ham")
                        Spacer()
                        Text("1 cup, chopped")
                    }
                    HStack {
                        Text("eggs")
                        Spacer()
                        Text("8")
                    }
                    HStack {
                        Text("milk")
                        Spacer()
                        Text("1/4 cup")
                    }
                    HStack {
                        Text("cheddar cheese")
                        Spacer()
                        Text("1/2 cup, shredded")
                    }
                    HStack {
                        Text("salt and ground black pepper")
                        Spacer()
                        Text("to taste")
                    }
                Group {
                    HStack {
                        Spacer()
                        Text("Steps")
                            .font(.headline)
                        Spacer()
                    }
                    Text("Preheat oven to 400 degrees F (200 degrees C). Grease a 10-inch round baking dish.")
                    Text("Melt butter in a large skillet over medium heat; cook and stir onion and bell pepper until softened, about 5 minutes. Stir in ham and continue cooking until heated through, 5 minutes more.")
                    Text("Beat eggs and milk in a large bowl. Stir in Cheddar cheese and ham mixture; season with salt and black pepper. Pour mixture into prepared baking dish.")
                    Text("Bake in preheated oven until eggs are browned and puffy, about 25 minutes. Serve warm.")
                }
            }
            Button(action: {}) {
                Image("Hat-icon")
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                
            }
        }.navigationBarTitle("View Recipe")
    }
    
}



struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}

