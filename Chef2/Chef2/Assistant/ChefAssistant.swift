//
//  ChefAssistant.swift
//  ChefAssistant
//
//  Created by Jason Clemens on 4/22/20.
//  Copyright © 2020 ExecutiveChef. All rights reserved.
//

import Foundation
import AssistantV2

class ChefAssistant {
    private static let assistantID = "cc108bc3-ffb0-4eea-a1a6-32f38872ddd8"
    private static let apiKey = "m4NfBL8geisdJ8g5USgAmCVdiHjl1FTIzDZNK2WAg2Ru"
    private static let apiVersion = "2020-04-01"
    private static let serviceURL = "https://api.us-south.assistant.watson.cloud.ibm.com/instances/b41046cc-67dd-4907-84cd-498c6630ffb4"
    
    static var instance: ChefAssistant {
        get {
            if _instance == nil {
				_instance = ChefAssistant(getWelcomeMessage: true)
            }
            return _instance!
        }
    }
    private static var _instance: ChefAssistant? = nil
    
    //Currently unused
    static func beginSession() {
        //ChefAssistant.instance._beginSession(getWelcomeMessage: true)
		if ChefAssistant._instance == nil {
			ChefAssistant._instance = ChefAssistant(getWelcomeMessage: false)
		}
		else if ChefAssistant._instance!.sessionID == "" {
			ChefAssistant._instance!._beginSession(getWelcomeMessage: false)
		}
    }
    
    static func deleteSession() {
        ChefAssistant.instance._deleteSession()
    }
    
    static func sendMessage(_ msg: String?, replyStringHandler: @escaping (String?) -> Void) {
        //TODO add a default callback that takes watson's response and passes it into the string (with nil if error)
        //ChefAssistant.sendMessageAdvanced(msg, **Custom default callback here**)
        
        ChefAssistant.sendMessageAdvanced(msg) { response, error in
            guard let message = response?.result else {
                print("sendMessage error: " + (error?.localizedDescription ?? "unknown error"))
                replyStringHandler(nil)
                return
            }
            var fragments: [String] = []
            message.output.generic?.forEach { fragment in
                if fragment.text != nil {
					fragments.append(Util.interpret(response: fragment.text!))
                } else {
                    print("sendMessage recieved response fragment with no text")
                }
            }
            replyStringHandler(fragments.joined(separator: "\n"))
        }
        
    }
    
    static func sendMessageAdvanced(_ msg: String?, completionHandler: @escaping (WatsonResponse<MessageResponse>?, WatsonError?) -> Void) {
        ChefAssistant.instance._sendMessage(msg, completionHandler: completionHandler)
    }
    
    
    private var assistant: Assistant
    private var sessionID = ""
    
	private init(getWelcomeMessage: Bool) {
        let authenticator = WatsonIAMAuthenticator(apiKey: ChefAssistant.apiKey)
        self.assistant = Assistant(version: ChefAssistant.apiVersion, authenticator: authenticator)
        self.assistant.serviceURL = ChefAssistant.serviceURL
        self._beginSession(getWelcomeMessage: getWelcomeMessage)
    }
    
    private func _beginSession(getWelcomeMessage: Bool) {
        let blocker = DispatchGroup()
        if self.sessionID == "" {
            blocker.enter()
            assistant.createSession(assistantID: ChefAssistant.assistantID) { response, error in
                guard let session = response?.result else {
                    print("createSession: " + (error?.localizedDescription ?? "unknown error"))
                    blocker.leave()
                    return
                }
                self.sessionID = session.sessionID
                blocker.leave()
            }
            resetSessionIn5Mins()
            blocker.wait()
        }
        if getWelcomeMessage {
            blocker.enter()
            self._sendMessage(nil, completionHandler: {_, _ in
                blocker.leave()
            })
            blocker.wait()
        }
    }
    
    weak static var timer: Timer?
    private func resetSessionIn5Mins() {
        ChefAssistant.timer?.invalidate()
        ChefAssistant.timer = Timer.scheduledTimer(withTimeInterval: 290.0, repeats: false) { _ in
            ChefAssistant.deleteSession()
            //ChefAssistant.beginSession()
        }
    }
    
    private func _deleteSession() {
        let blocker = DispatchGroup()
        blocker.enter()
        self.assistant.deleteSession(assistantID: ChefAssistant.assistantID, sessionID: self.sessionID) { response, error in
            blocker.leave()
        }
        blocker.wait()
        self.sessionID = ""
    }
    
    private func _sendMessage(_ msg: String?, completionHandler: @escaping (WatsonResponse<MessageResponse>?, WatsonError?) -> Void) {
        if self.sessionID == "" {
            self._beginSession(getWelcomeMessage: msg != nil)
        }
        if msg == nil {
            self.assistant.message(assistantID: ChefAssistant.assistantID, sessionID: self.sessionID, completionHandler: completionHandler)
        } else {
            let messageInput = MessageInput(messageType: "text", text: msg!)
            self.assistant.message(assistantID: ChefAssistant.assistantID, sessionID: self.sessionID, input: messageInput, completionHandler: completionHandler)
        }
    }
}
