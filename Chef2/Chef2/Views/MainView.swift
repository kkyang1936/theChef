//
//  ContentView.swift
//  Chef
//
//  Created by Nicholas Motlagh on 1/21/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI

struct BlurCard: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemThinMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                ZStack {
                    BlurCard()
                        .frame(width: 280, height: 250)
                        .cornerRadius(20)
                    VStack {
                        Text("Chef")
                            .font(.largeTitle)
                            .offset(y: -10)
                        NavigationLink(destination: /*SearchView()*/
                            SearchView2()) {
                            Text("Find a new Recipe")
                                .frame(width: 200)
                                .padding()
                                .background(Color.white).cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke())
                        }.padding()
                        NavigationLink(destination: HistoryView()) {
                            Text("History")
                                .frame(width: 200)
                                .padding().background(Color.white).cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke())
                        }
                    }.padding()
                }
                Spacer()
                NavigationLink(destination: ChatView()) {
                    Image("Hat-icon")
                    .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    .padding()
                    .background(BlurCard())
                    .cornerRadius(15)
                    }.padding()
            }
        .background(Image("FoodBackground"))
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
