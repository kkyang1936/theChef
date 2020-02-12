import SwiftSoup
import Foundation

class Scraper {
    public private(set) var ingredients = [String]()
    public private(set) var steps = [String]()
    public private(set) var imageUrl = String()
    public private(set) var name = String()
    private let urls = ["https://www.allrecipes.com/recipe/262161/chef-johns-lobster-thermidor/", "https://www.allrecipes.com/recipe/17456/golden-rum-cake/?internalSource=hub%20recipe&referringContentType=Search"]
    
    func scrape() {
        do {
            let urlString = "https://www.allrecipes.com/recipe/262161/chef-johns-lobster-thermidor/"
            guard let url = URL(string: urlString) else {
                print("Error: \(urlString) doesn't seem to be a valid URL")
                return
            }
            let html = try! String(contentsOf: url, encoding: .utf8)
            let doc: Document = try SwiftSoup.parse(html)
            ingredients = getIngredientsStrings(doc: doc)
            steps = getStepsStrings(doc: doc)
            imageUrl = getImageUrl(doc: doc)
            name = getName(doc: doc)
        } catch Exception.Error(let message) {
            print(message)
        } catch {
            print("error")
        }
    }
    
    private func getIngredientsStrings(doc: Document) -> [String] {
        var ingredientsElements = Elements()
        var ingredientsStrings = [String]()
        do {
            ingredientsElements = try doc.select("li.checklist__line")
        } catch Exception.Error(let message) {
            print(message)
        } catch {
            print("error getting elements")
        }
        do {
            for element in ingredientsElements {
                if try element.text() != "Add all ingredients to list" {
                    try ingredientsStrings.append(element.text())
                }
            }
        } catch Exception.Error(let message) {
            print(message)
        } catch {
            print("Error taking text from elements")
        }
        return ingredientsStrings
    }
    
    private func getStepsStrings(doc: Document) -> [String] {
        var stepsElements = Elements()
        var stepsStrings = [String]()
        do {
            stepsElements = try doc.select("li.step")
        } catch Exception.Error(let message){
            print(message)
        } catch {
            print("Error getting step elements")
        }
        do {
            for element in stepsElements {
                try stepsStrings.append(element.text())
            }
        } catch Exception.Error(let message){
            print(message)
        } catch {
            print("Error taking text from elements")
        }
        return stepsStrings
    }
    
    private func getImageUrl(doc: Document) -> String {
        var src = String()
        do {
            let photoStrip = try doc.select("ul.photo-strip__items")
            let photo = photoStrip.first()
            src = try (photo?.select("img").attr("src") ?? "error")
        } catch Exception.Error(let message) {
            print(message)
        } catch {
            print("Error getting image url")
        }
        return src
    }
    
    private func getName(doc: Document) -> String {
        var name = String()
        do {
            let nameElement = try doc.select("h1.recipe-summary__h1")
            name = try nameElement.text()
        } catch Exception.Error(let message) {
            print(message)
        } catch {
            print("Error getting name of recipe")
        }
        return name
    }
}
