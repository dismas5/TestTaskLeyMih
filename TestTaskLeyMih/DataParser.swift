import Foundation

class DataParser {
    
    init() {
        JsonLink = ""
        pagesAmount = 0
        //TODO: Get information about pages automatically, not by entering Int number
    }
    
    init(link: String, pages: Int) {
        JsonLink = link
        pagesAmount = pages
    }
    
    public var characters: [Character] = [Character]()
    private var pagesAmount: Int
    private var JsonLink: String
    
    func getCharacters() -> [Character] {
        return characters
    }
    
    func parseData() {
        for i in 1...self.pagesAmount {
            if let url = URL(string: self.JsonLink + "?page=\(i)") {
                URLSession.shared.dataTask(with: url) { [self] data, _, error in
                    if let data = data {
                    do {
                        characters += try JSONDecoder().decode(RawData.self, from: data).results
                        print("Page \(i) exported successfully!")
                    } catch {
                        print("Error: \(error)")
                    }
                    }
                }.resume()
            }
        }
    }
}
