//
//  AssistantAudioInteraction.swift
//  Chef2
//
//  Created by Jason Clemens on 4/21/20.
//  Copyright © 2020 ExecutiveChef. All rights reserved.
//

import Foundation
import AssistantV2

class ChefAssistant {
	public static var instance: ChefAssistant {
		get {
			if _instance == nil {
				_instance = ChefAssistant()
			}
			return _instance!
		}
	}
	private static var _instance: ChefAssistant?
	
	var assistant: Assistant
	var assistantID = "cc108bc3-ffb0-4eea-a1a6-32f38872ddd8"
	var sessionID = ""
	
	private init() {
		let authenticator = WatsonIAMAuthenticator(apiKey: "EpjoK7b6RbJ1zA4To4qL79tchEpsbcZ1ZgsFXeDe6CGz")
		self.assistant = Assistant(version: "2020-03-04", authenticator: authenticator)
		self.assistant.serviceURL = "https://api.us-south.assistant.watson.cloud.ibm.com/instances/b41046cc-67dd-4907-84cd-498c6630ffb4"
		newSession()
	}
	
	static func createNewSession() {
		ChefAssistant.instance.newSession()
	}
	
	private func newSession() {
		self.assistant.createSession(assistantID: self.assistantID) { response, error in
			guard let session = response?.result else {
				print("unable to create session: " + (error?.localizedDescription ?? "unknown error"))
				return
			}
			self.sessionID = session.sessionID
		}
	}
	
	static func deleteSession() {
		ChefAssistant.instance._deleteSession()
	}
	
	private func _deleteSession() {
		self.assistant.deleteSession(assistantID: self.assistantID, sessionID: sessionID) { _, error in
			print(error?.localizedDescription ?? "unknown error in _deleteSession()")
		}
		self.sessionID = ""
	}
	
	//callback with string
	static func sendMessage(_ msg: String?, callback: @escaping (String?) -> ()) {
		ChefAssistant.instance._sendMessage(msg) { response, error in
			guard let reply = response?.result else {
				print("sendMessage no response result")
				print(error?.localizedDescription ?? "unknown error in _sendMessage()")
				callback(nil)
				return
			}
			var fullResponse = ""
			reply.output.generic?.forEach { responseFragment in
				if responseFragment.text != nil {
					fullResponse += Util.interpret(response: responseFragment.text!) + "\n"
				}
			}
			fullResponse = String(fullResponse.dropLast())
			callback(fullResponse)
		}
	}
	
	static func sendMessageAdvanced(_ msg: String?, completionHandler: @escaping (WatsonResponse<MessageResponse>?, WatsonError?) -> Void) {
		ChefAssistant.instance._sendMessage(msg, completionHandler: completionHandler)
	}
	
	private func _sendMessage(_ msg: String?, completionHandler: @escaping (WatsonResponse<MessageResponse>?, WatsonError?) -> Void) {
		if msg == nil {
			self.assistant.message(assistantID: self.assistantID, sessionID: self.sessionID, completionHandler: completionHandler)
		} else {
			self.assistant.message(assistantID: self.assistantID, sessionID: self.sessionID, input: MessageInput(messageType: "text", text: msg!), completionHandler: completionHandler)
		}
	}
	
}
