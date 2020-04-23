//
//  Util.swift
//  Chef
//
//  Created by Nicholas Motlagh on 3/3/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import Foundation
class Util {
    
    //interpret the string from watson
    //{{readStep, n
    //{{
    public static func interpret(response: String) -> String{
        //check if we are calling a function or forwarding a response
        //check if {{ is in the string
        if response.contains("{{"){
            //we are looking at a function call
            var paramsList = response.split(separator: ",")
            
            //remove {{
            paramsList[0].removeFirst()
            paramsList[0].removeFirst()
            //look at the first element in the comma separated list
            switch String(paramsList[0]) {
            case "readStep":
                let step = Int(paramsList[1]) ?? 0
				return readStep(n: step)
            case "listIngredients":
                return listIngredients()
            case "timerRequest":
                //timer request
                return "timer-request"+timerRequest(timer: String(paramsList[1]))
            case "checkIngredients":
                var ingred_list: [String] = [String]()
                for (index, ingredient) in paramsList.enumerated(){
                    if index != 0{
                        ingred_list.append(checkIngredient(ingredient: String(ingredient)))
                    }
                }
                return ingred_list.joined(separator: "\n")
            case "timerSet":
				return setTimer(endTime: String(paramsList[1]))
            case "getIngredients":
                return getIngredients()
            default:
                //did not get what youre looking for
                return "i did not get your response"            }
            
        }else{
            //just a regular watson response
            return response
        }
    }
    
    //read the nth step in the sequence
    private static func readStep(n: Int) -> String{
        //Make watson respond with
		guard lastOpenRecipe != nil else {
			return "You aren't currently in the middle of any recipes."
		}
        if n >= lastOpenRecipe!.steps.count{
            return "You're done!"
        }
        return "Here's step \(n+1): \n" + lastOpenRecipe!.steps[n]
    }
    
    // list the required ingredients
    private static func listIngredients() -> String{
		guard lastOpenRecipe != nil else {
			return "You aren't currently in the middle of any recipes."
		}
        //Make watson respond with
        return "You will need the following... " + lastOpenRecipe!.ingredients.joined(separator: ", ")
    }
    
    private static func timerRequest(timer: String) -> String{
        // send this to watson
        return timer + " from now"
    }
    private static func checkIngredient(ingredient: String) -> String {
		guard lastOpenRecipe != nil else {
			return "You aren't currently in the middle of any recipes."
		}
        var requiredIngredient = false
        var ingredient_index = -1
        for (index, ingredient_i) in lastOpenRecipe!.ingredients.enumerated(){
            if ingredient_i.contains(ingredient){
                requiredIngredient = true
                ingredient_index = index
            }
        }
        if requiredIngredient{
            return "You need " + lastOpenRecipe!.ingredients[ingredient_index]
        }else{
            return "You don't need " + ingredient
        }
    }
    private static func getIngredients() -> String{
		guard lastOpenRecipe != nil else {
			return "You aren't currently in the middle of any recipes."
		}
        return lastOpenRecipe!.ingredients.joined(separator: "\n")
    }
	
	private static func setTimer(endTime: String) -> String {
		/*
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "un_US_POSIX")
		formatter.dateFormat = "HH:mm:ss"
		formatter.timeZone = Calendar.current.timeZone
		guard var timerEnd = formatter.date(from: endTime) else {
			return "Sorry, I couldn't set a timer properly."
		}
		
		timerEnd = Date().addingTimeInterval(timerEnd.timeIntervalSinceReferenceDate)
		*/
		let endTimeSplit = endTime.split(separator: ":")
		guard
			let hour = Int(String(endTimeSplit[0])),
			let minute = Int(String(endTimeSplit[1])),
			let second = Int(String(endTimeSplit[2])),
			let timerEnd = Calendar.current.date(bySettingHour: hour, minute: minute, second: second, of: Date())
			else {
			return "Sorry, I couldn't set a timer properly"
		}
		
		//DEBUG
		let df = DateFormatter()
		df.dateStyle = .medium
		df.timeStyle = .medium
		df.timeZone = Calendar.current.timeZone
		print("Timer end date: " + df.string(from: timerEnd))
		
		
		if timerEnd < Date() {
			return "Your timer has already ended."
		}
		else {
			NotificationManager.registerLocalTimerNotification(displayAt: timerEnd)
		}
		return "Okay, I set a timer."
	}
    
}
