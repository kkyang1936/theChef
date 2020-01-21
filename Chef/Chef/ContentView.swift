//
//  ContentView.swift
//  Chef
//
//  Created by Nicholas Motlagh on 1/21/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Chef")
                .font(.largeTitle)
                .padding()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Text("Find a new Recipe")
                .padding()
            }
            Button(action: {}) {
                Text("History")
                .padding()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
