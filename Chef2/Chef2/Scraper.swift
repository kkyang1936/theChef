import SwiftSoup
import Foundation

class Scraper {
    public private(set) var ingredients = [String]()
    public private(set) var steps = [String]()
    public private(set) var imageUrl = String()
    public private(set) var name = String()
    
    private func scrape(_ urlString: String) {
        do {
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
        } catch {
            print("error")
        }
    }
    
    private func getIngredientsStrings(doc: Document) -> [String] {
        var ingredientsElements = Elements()
        var ingredientsStrings = [String]()
        do {
            ingredientsElements = try doc.select("li.ingredients-item")
            if (ingredientsElements.size() == 0) {
                ingredientsElements = try doc.select("li.checklist__line")
            }
        } catch {
            print("Error getting ingredients elements.")
        }
        for element in ingredientsElements {
            do {
                let next = try element.text()
                if (!next.isEmpty && next != "Add all ingredients to list") {
                    ingredientsStrings.append(next)
                }
            } catch {
                print("Error taking text from ingredients elements.")
            }
        }
        
        /*
        do {
            for element in ingredientsElements {
                if try element.text() != "Add all ingredients to list" {
                    try ingredientsStrings.append(element.text())
                }
            }
        } catch Exception.Error(let message) {
            print(message)
        } catch {
            print("Error taking text from ingredients elements.")
        }
 */
        return ingredientsStrings
    }
    
    private func getStepsStrings(doc: Document) -> [String] {
        var stepsElements = Elements()
        var stepsStrings = [String]()
        do {
            stepsElements = try doc.select("li.subcontainer.instructions-section-item div.section-body")
            if (stepsElements.size() == 0) {
                stepsElements = try doc.select("li.step")
			}
        } catch {
            print("Error getting steps elements.")
        }
        for element in stepsElements {
            do {
                let next = try element.text()
                if (!next.isEmpty) {
                    stepsStrings.append(next)
                }
            } catch {
                print("Error taking text from steps elements.")
            }
        }
        return stepsStrings
    }
    
    private func getImageUrl(doc: Document) -> String {
        var src = String()
        do {
            var photoStrip = try doc.select("div.inner")
            if (photoStrip.size() == 0) {
                photoStrip = try doc.select("ul.photo-strip__items")
            }
            let photo = photoStrip.first()!
            src = try (photo.select("img").attr("src"))
        } catch {
            print("Error getting image url")
        }
        return src
    }
    
    private func getName(doc: Document) -> String {
        var name = String()
        do {
            var nameElement = try doc.select("h1.recipe-summary__h1")
            if (nameElement.size() == 0) {
                nameElement = try doc.select("h1.headline.heading-content")
            }
            name = try nameElement.text()
        } catch {
            print("Error getting name of recipe")
        }
        return name
    }
    
    public func getScrapeStruct(url: String) -> Recipe {
        scrape(url)
        return Recipe(name: self.name,
                      imageURL: URL(string: self.imageUrl),
                      ingredients: self.ingredients,
                      steps: self.steps)
    }
}
