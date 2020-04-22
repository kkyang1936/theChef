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
    
    func addMessageToHistory(_ chatMessage: Message) {
        DispatchQueue.main.async {
            self.realTimeMessages.append(chatMessage)
        }
        didChange.send(())
    }

    func instantiateAssistant() {
		ChefAssistant.beginSession()
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
				let correctResponse = Util.interpret(response: response.text ?? "Wrong response")
				TextToSpeech().speak(words: correctResponse)
				self.addMessageToHistory(Message(content: correctResponse, user: DataSource.Watson))
			}
		}
    }
    
    func beginConversation() {
		ChefAssistant.sendMessageAdvanced(nil) { response, error in
			guard let message = response?.result else {
				print("beginConversation: " + (error?.localizedDescription ?? "unknown error"))
				return
			}
			message.output.generic?.forEach { response in
				print(response.text ?? "No response")
				self.addMessageToHistory(Message(content: response.text ?? "No Response", user: DataSource.Watson))
			}
		}
    }

}
