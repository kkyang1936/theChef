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
        VStack{
            HStack {
                VStack {
                    Text("Baked Denver Omelet")
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        Text("Tell me about \n the recipe")
                            .font(.subheadline)
                            .colorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
                            .buttonStyle(/*@START_MENU_TOKEN@*/ /*@PLACEHOLDER=Button Style@*/DefaultButtonStyle()/*@END_MENU_TOKEN@*/)
                            .clipped()
                            .background(/*@START_MENU_TOKEN@*/Color.white
                                .contentShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                .font(/*@START_MENU_TOKEN@*/.body/*@END_MENU_TOKEN@*/)
                                /*@END_MENU_TOKEN@*/)
                    }
                }
                Image("Omelette")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                
            
            }.padding()
            List {
                HStack {
                    Text("Ingredients")
                        .font(.title)
                        
                    //Text("      Quantity")
                }
                
                    Text("butter    2 tablespoons")
                    Text("onion     1/2, chopped")
                    Text("green bell pepper     1/2, chopped")
                    Text("ham       1 cup chopped cooked ")
                    Text("eggs      8")
                    Text("milk      1/4 cup ")
                    Text("Cheddar cheese        1/2 cup shredded ")
                    Text("salt and ground black pepper to taste")

            }
            
            List {
                HStack {
                    Text("Steps")
                        .font(.title)
                        
                    //Text("      Quantity")
                }
                
                    Text("Preheat oven to 400 degrees F (200 degrees C). Grease a 10-inch round baking dish.")
                    Text("Melt butter in a large skillet over medium heat; cook and stir onion and bell pepper until softened, about 5 minutes. Stir in ham and continue cooking until heated through, 5 minutes more.")
                    Text("Beat eggs and milk in a large bowl. Stir in Cheddar cheese and ham mixture; season with salt and black pepper. Pour mixture into prepared baking dish.")
                    Text("Bake in preheated oven until eggs are browned and puffy, about 25 minutes. Serve warm.")

            }
            
            
        }.padding().border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }
}



struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}

