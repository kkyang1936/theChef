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
            Spacer()
            Text("Chef")
                .font(.largeTitle)
                .padding()
            Button(action: {}) {
                Text("Find a new Recipe")
                .padding()
            }
            Button(action: {}) {
                Text("History")
                .padding()
            }
            Spacer()
            Button(action: {}) {
                Image("Hat-icon")
                .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
            }.padding()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
