import SwiftSoup
import Foundation

class Scraper {
    private var ingredients = [String]()
    private var steps = [String]()
    
    func scrape() -> [String] {
        do {
            let urlString = "https://www.allrecipes.com/recipe/17456/golden-rum-cake/?internalSource=hub%20recipe&referringContentType=Search"
            guard let url = URL(string: urlString) else {
                print("Error: \(urlString) doesn't seem to be a valid URL")
                return ["error"]
            }
            let html = try! String(contentsOf: url, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            ingredients = getIngredients(doc: doc)
        } catch Exception.Error(let message) {
            print(message)
        } catch {
            print("error")
        }
        print(ingredients)
        return ingredients
    }
    
    func getIngredients(doc: Document) -> [String] {
        var ingredientsElements = Elements()
        var ingredientsStrings = [String]()
        do {
            ingredientsElements = try doc.select("li.checklist__line")
        } catch Exception.Error(let message){
            print(message)
        } catch {
            print("error getting elements")
        }
        do {
            for element in ingredientsElements {
                try ingredientsStrings.append(element.text())
            }
        } catch Exception.Error(let message){
            print(message)
        } catch {
            print("Error taking text from elements")
        }
        return ingredientsStrings
    }
}
