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
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                    
                    }.padding()
                    Spacer()
                    Image("omelette")
                        .resizable()
                        .clipShape(Circle())
                        .multilineTextAlignment(.trailing)
                        .frame(width:100, height: 100)
                }
                HStack() {
                    Text("Eggs Benedict")
                        .font(.largeTitle)
                        .fontWeight(.light)
                    Spacer()
                    Image("eggs_benedict")
                        .resizable()
                        .clipShape(Circle())
                        .multilineTextAlignment(.trailing)
                        .frame(width:100, height: 100)
                }
                HStack() {
                    Text("Scrambled Eggs")
                        .font(.largeTitle)
                        .fontWeight(.light)
                    Spacer()
                    Image("scrambled_eggs")
                        .resizable()
                        .clipShape(Circle())
                        .multilineTextAlignment(.trailing)
                        .frame(width:100, height: 100)
                }
        }.background(/*@START_MENU_TOKEN@*/Color.yellow/*@END_MENU_TOKEN@*/)
            
    }
}


struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ResultsView()
    }
}
