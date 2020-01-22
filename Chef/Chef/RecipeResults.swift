//
//  SearchView.swift
//  Chef
//
//  Created by Jason Clemens on 1/22/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI

//struct ResultsView: View{
//    @State private var results = [Recipes]()
//    var body: some View {
//        VStack {
//            Image(systemName: "magnifyingglass")
//            TextField("Search Recipes", text: $searchText)
//                .frame(width: 320, height: 35)
//
//                .background(Color.init( red: 0.9, green: 0.9, blue: 0.9, opacity: 1))
//            .cornerRadius(5)
//        }
//    }
//}

struct ResultsView: View {
    var body: some View {
        List {
                HStack() {
                    NavigationLink(destination: ContentView()) {
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
