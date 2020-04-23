//
//  ContentView.swift
//  ChefAssistant
//
//  Created by Jason Clemens on 4/22/20.
//  Copyright © 2020 ExecutiveChef. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var label = "Hello, World"
    var body: some View {
        Text(label)
            .onAppear {
                DispatchQueue.main.async {
                    ChefAssistant.sendMessage("What's the first step", replyStringHandler: { reply in
                        self.label = reply ?? "nil"
                    })
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
