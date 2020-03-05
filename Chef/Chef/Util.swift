//
//  Util.swift
//  Chef
//
//  Created by Nicholas Motlagh on 3/3/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import Foundation
class Util {
    //watson connection
    public var Watson = String()
    
    //interpret the string from watson
    //{{readStep, n
    //{{
    public func interpret(response: String) {
        //check if we are calling a function or forwarding a response
        //check if {{ is in the string
        if response.contains("{{"){
            //we are looking at a function call
            var paramsList = response.split(separator: ",")
            
            //remove {{
            let range = paramsList[0].index(paramsList[0].startIndex, offsetBy: 2)..<paramsList[0].endIndex
            paramsList[0].removeSubrange(range)
            
            //look at the first element in the comma separated list
            switch String(paramsList[0]) {
            case "readStep":
                let step = Int(paramsList[1]) ?? 0
                readStep(n: step)
            case "listIngredients":
                listIngredients()
            case "timerRequest":
                let newRequest = timerRequest(timer: String(paramsList[1]))
            case "checkIngredients":
                for (index, ingredient) in paramsList.enumerated(){
                    if index != 1{
                        checkIngredient(ingredient: String(ingredient))
                    }
                }
            case "getTimer":
                getTimer(timer: String(paramsList[1]))
            default:
                //did not get what youre looking for
                print("i did not get your response")            }
            
        }else{
            //just a regular watson response
            print(response)
        }
        
    }
    
    //read the nth step in the sequence
    private func readStep(n: Int) -> String{
        //Make watson respond with
        return "Here's step \(n): \n" + Recipe.steps[n]
    }
    
    // list the required ingredients
    private func listIngredients() -> [String]{
        //Make watson respond with
        return "You will need the following...\n" + Recipe.ingredients
    }
    
    private func timerRequest(timer: String) -> String{
        // send this to watson
        return Watson.call(timer + " from now")
    }
    private func checkIngredient(ingredient: String) -> String{
        var requiredIngredient = false
        var ingredient_index = -1
        for (index, ingredient_i) in Recipe.ingredients.enumerated(){
            if ingredient_i.contains(ingredient){
                requiredIngredient = true
                ingredient_index = index
            }
        }
        if requiredIngredient{
            return "You need " + Recipe.ingredients[ingredient_index]
        }else{
            return "You don't need " + ingredient
        }
    }
    private func getTimer(timer: String){
        var dateParse = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US")

        let dateString = dateFormatter.string(from: Date())
        let dateNSDate = dateFormatter.date(from: timer) //date = "14:05"
        let currentDate = dateFormatter.date(from: dateString)
        let timeInterval = currentDate.timeIntervalSince(dateNSDate?)
    }
    
}

