//
//  IngredientRecognition.swift
//  Chef2
//
//  Created by Jason Clemens on 4/21/20.
//  Copyright © 2020 ExecutiveChef. All rights reserved.
//

import Foundation
import VisualRecognitionV3

class IngredientRecognition {
	public static var instance: IngredientRecognition {
		get {
			if IngredientRecognition._instance == nil {
				IngredientRecognition._instance = IngredientRecognition()
			}
			return IngredientRecognition._instance!
		}
	}
	private static var _instance: IngredientRecognition? = nil
	private var visualRecognition: VisualRecognition
	
	
	init() {
		let authenticator = WatsonIAMAuthenticator(apiKey: "MVNfbZpbnmxnISGYlwb5fkESeWaEpspvBYfeEb39aUNu")
		self.visualRecognition = VisualRecognition(version: "2018-03-19", authenticator: authenticator)
		visualRecognition.serviceURL = "https://api.us-south.visual-recognition.watson.cloud.ibm.com/instances/8d25e451-247e-4c89-b5ac-caf11a1203f4"
	}
	
	func recognizeIngredient(photoFile: Data, callback: @escaping (String?) -> ()) {
		visualRecognition.classify(imagesFile: photoFile, classifierIDs: ["food"]) { response, error in
			guard let result = response?.result else {
				print(error?.localizedDescription ?? "visual recognition: unknown error")
				callback(nil)
				return
			}
			if result.images[0].classifiers[0].classes.isEmpty {
				print("No classes")
				callback(nil)
				return
			}
			let classification = result.images[0].classifiers[0].classes[0].class
			if classification == "non-food" {
				print("Non-food")
				callback(nil)
				return
			}
			callback(classification)
		}
	}
}
