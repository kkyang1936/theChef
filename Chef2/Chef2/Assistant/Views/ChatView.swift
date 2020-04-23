//
//  ContentView.swift
//  ChatViewTutorial
//
//  Created by Stephen Radvansky on 2/2/20.
//  Copyright © 2020 Stephen Radvansky. All rights reserved.
//

import SwiftUI

struct ChatView: View {
    @State var typingMessage: String = ""
    @EnvironmentObject var chatHelper: ChatHelper
    @ObservedObject private var keyboard = KeyboardResponder()
    @State var data = DataSource()
    @State var transcribedText = ""
    
    init() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(chatHelper.realTimeMessages, id: \.self) { msg in
                        MessageView(currentMessage: msg)
                        
                    }
                }
                HStack {
                    TextField("Message...", text: $typingMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: CGFloat(30))
                    Button(action: sendMessage) {
                        Text("Send")
                    }
                }.frame(minHeight: CGFloat(50)).padding()
                VStack{
                    Button(action:{
                        self.recordAndSend()
                    }) {
                        Text("Record And Send")
                    }
                    Text("transcription: " + self.transcribedText)
                        .font(.system(size: 12, weight: .light, design: .serif))
                        .italic()
                    
                    
                }
                
            }.navigationBarTitle(Text(DataSource.Watson.name), displayMode: .inline)
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(keyboard.currentHeight == 0.0 ? .leading: .bottom)
        }.onTapGesture {
                self.endEditing(true)
        }.onAppear{
            self.chatHelper.instantiateAssistant()
        }.onDisappear(){
            self.chatHelper.deleteAssistant()
        }
    }
    
    func recordAndSend(){
        SpeechToText().recognize(){(result)in
            self.typingMessage = result
            self.transcribedText = result
            self.sendMessage()
            print("final result:" + result)
         }
        
    }
    
    func sendMessage() {
		chatHelper.addMessageToHistory(Message(content: typingMessage, user: DataSource.currentUser))
        chatHelper.sendMessage(text: typingMessage)
        typingMessage = ""
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
