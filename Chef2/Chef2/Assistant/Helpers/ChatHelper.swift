//
//  ChatHelper.swift
//  ChatViewTutorial
//
//  Created by Stephen Radvansky on 3/2/20.
//  Copyright © 2020 Stephen Radvansky. All rights reserved.
//

import Combine
import AssistantV2
import Foundation
class ChatHelper : ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    @Published var realTimeMessages = [Message]()
    
    func sendMessage(_ chatMessage: Message) {
        DispatchQueue.main.async {
            self.realTimeMessages.append(chatMessage)
        }
        didChange.send(())
    }
    
    //var assistant: Assistant?
    //var sessionID: String = ""
    //let assistantID = "cc108bc3-ffb0-4eea-a1a6-32f38872ddd8"
    

    func instantiateAssistant() {
		self.beginConversation()
    }
    
    func deleteAssistant(){
		ChefAssistant.deleteSession()
    }
    
    func sendMessage(text: String) {
		ChefAssistant.sendMessageAdvanced(text) { response, error in
			guard let message = response?.result else {
				print(error?.localizedDescription ?? "unknown error")
				return
			}
			message.output.generic?.forEach { response in
				print(response.text ?? "No response")
				//TODO change Util.interpret to check for presence of lastOpenRecipe and give different interpretations based on that
				let correctResponse = Util.interpret(response: response.text ?? "Wrong response")
				TextToSpeech().speak(words: correctResponse)
				self.sendMessage(Message(content: correctResponse, user: DataSource.Watson))
			}
		}
    }
    
    func beginConversation() {
		ChefAssistant.sendMessageAdvanced(nil) { response, error in
			guard let message = response?.result else {
				print(error?.localizedDescription ?? "unknown error")
				return
			}
			message.output.generic?.forEach { response in
				print(response.text ?? "No response")
				self.sendMessage(Message(content: response.text ?? "No Response", user: DataSource.Watson))
			}
		}
    }

}
