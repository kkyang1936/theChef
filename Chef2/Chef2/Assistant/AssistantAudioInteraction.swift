//
//  AssistantAudioInteraction.swift
//  Chef2
//
//  Created by Jason Clemens on 4/21/20.
//  Copyright © 2020 ExecutiveChef. All rights reserved.
//

import Foundation
import AVFoundation
import AssistantV2

class AssistantAudioInteraction {
	static func playStartAudioCue() {
		AudioServicesPlaySystemSound(SystemSoundID(1117)) //BeginVideoRecording
	}
	
	static func playEndAudioCue() {
		AudioServicesPlaySystemSound(SystemSoundID(1118)) //EndVideoRecording
	}
	
	static func sendVoiceToAssistant(callback: @escaping (String?) -> () = AssistantAudioInteraction.readAssistantResponse) {
		SpeechToText().recognize { transcription in
			ChefAssistant.sendMessage(transcription) { result in
				callback(result)
			}
		}
	}
	
	static func sendVoiceToAssistantAdvanced(onVoiceTranscribed: @escaping (String) -> Void, onWatsonResponse: @escaping (WatsonResponse<MessageResponse>?, WatsonError?) -> Void) {
		SpeechToText().recognize { transcription in
			onVoiceTranscribed(transcription)
			ChefAssistant.sendMessageAdvanced(transcription, completionHandler: onWatsonResponse)
		}
	}
	
	static func readAssistantResponse(_ reply: String?) {
		guard let reply = reply else { return }
		TextToSpeech().speak(words: reply)
	}
	
}
