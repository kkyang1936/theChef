//
//  ChatHelper.swift
//  ChatViewTutorial
//
//  Created by Stephen Radvansky on 3/2/20.
//  Copyright © 2020 Stephen Radvansky. All rights reserved.
//

import Combine
import AssistantV2
class ChatHelper : ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    @Published var realTimeMessages = [Message]()
    
    func sendMessage(_ chatMessage: Message) {
        DispatchQueue.main.async {
            self.realTimeMessages.append(chatMessage)
        }
        didChange.send(())
    }
    
    var assistant: Assistant?
    var sessionID: String = ""
    let assistantID = "cc108bc3-ffb0-4eea-a1a6-32f38872ddd8"
    

    func instantiateAssistant() {
        let authenticator = WatsonIAMAuthenticator(apiKey: "EpjoK7b6RbJ1zA4To4qL79tchEpsbcZ1ZgsFXeDe6CGz")
        assistant = Assistant(version: "2020-03-04", authenticator: authenticator)
        
        assistant?.serviceURL = "https://api.us-south.assistant.watson.cloud.ibm.com/instances/b41046cc-67dd-4907-84cd-498c6630ffb4"
        

        assistant?.createSession(assistantID: assistantID) {
          response, error in
          guard let session = response?.result else {
            print(error?.localizedDescription ?? "unknown error")
            return
          }
            
            self.sessionID = session.sessionID
            self.beginConversation(sessID: self.sessionID)
          print(session)
          
            
        }
    }
    
    func deleteAssistant(){
        
        assistant?.deleteSession(assistantID: assistantID, sessionID: sessionID) {
          _, error in
          
          if let error = error {
            print(error.localizedDescription)
            return
          }
            
          
        }
        print("session deleted")
    }
    
    func sendMessage(text: String){
        let input = MessageInput(messageType: "text", text: text)

        assistant?.message(assistantID: assistantID, sessionID: sessionID, input: input) {
          response, error in

          guard let message = response?.result else {
            print(error?.localizedDescription ?? "unknown error")
            return
          }
          
            
            message.output.generic?.forEach({ response in
                print(response.text ?? "No response")
                let correctResponse = Util.interpret(response: response.text ?? "Wrong response")
                self.sendMessage(Message(content: correctResponse, user: DataSource.Watson))
            })
        }
    }
    
    func beginConversation(sessID: String){
        assistant?.message(assistantID: assistantID, sessionID: sessID) {
          response, error in

          guard let message = response?.result else {
            print(error?.localizedDescription ?? "unknown error")
            return
          }
            
            
            message.output.generic?.forEach({ response in
                print(response.text ?? "No response")
                self.sendMessage(Message(content: response.text ?? "No Response", user: DataSource.Watson))
            })
        }
    }

}
