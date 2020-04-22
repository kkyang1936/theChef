//
//  AssistantAudioInteraction.swift
//  Chef2
//
//  Created by Jason Clemens on 4/21/20.
//  Copyright © 2020 ExecutiveChef. All rights reserved.
//

import Foundation
import AVFoundation

class AssistantAudioInteraction {
	static func playStartAudioCue() {
		AudioServicesPlaySystemSound(SystemSoundID(1117)) //BeginVideoRecording
	}
	
	static func playEndAudioCue() {
		AudioServicesPlaySystemSound(SystemSoundID(1118)) //EndVideoRecording
	}
	
	static func sendVoiceToAssistant(callback: @escaping (String?) -> () = AssistantAudioInteraction.readAssistantResponse) {
		SpeechToText().recognize { transcription in
			ChefAssistant.sendMessage(transcription, callback: callback)
		}
	}
	
	static func readAssistantResponse(_ reply: String?) {
		guard let reply = reply else { return }
		TextToSpeech().speak(words: reply)
	}
	
}
