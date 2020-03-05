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
            case "getTimer":
                let inprogress = "Working on this part";
                return "hi"
            case "getIngredients":
                return getIngredients()
                //getTimer(timer: String(paramsList[1]))
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
        if n >= lastOpenRecipe!.steps.count{
            return "You're done!"
        }
        return "Here's step \(n+1): \n" + lastOpenRecipe!.steps[n]
    }
    
    // list the required ingredients
    private static func listIngredients() -> String{
        //Make watson respond with
        return "You will need the following... " + lastOpenRecipe!.ingredients.joined(separator: ", ")
    }
    
    private static func timerRequest(timer: String) -> String{
        // send this to watson
        return timer + " from now"
    }
    private static func checkIngredient(ingredient: String) -> String{
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
        return lastOpenRecipe!.ingredients.joined(separator: "\n")
    }
    
    /*
     ////IN PROGRESS
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
     
     */
    
    
}
