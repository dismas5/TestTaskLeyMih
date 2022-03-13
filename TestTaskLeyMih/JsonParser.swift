import Foundation

class DataParser {
    
    init() {
        characters = [Character]()
        //TODO: Get information about pages automatically, not by entering Int number
        pagesAmount = 42
    }
    
    public var characters: [Character]
    private var pagesAmount: Int
    let JsonLink = "https://rickandmortyapi.com/api/character/"
    
    func printData() {
        print(characters.count)
        for character in characters {
            print("\(character.id) \(character.name)")
        }
    }
    
    func getCharactersAmount() -> Int {
        return characters.count
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
    
    func getCharacterById(_ id: Int) -> Character {
        return characters[id]
    }
    
    func getCharacterInfo(_ character: Character) {
        //TODO: Add origin and location
        
        print("Id: \(character.id)")
        print("Name: \(character.name)")
        print("Status: \(character.status)")
        print("Species: \(character.species)")
        print("Type: \(character.type)")
        print("Gender: \(character.gender)")
        print("Image: \(character.image)")
        
        print("List of episodes:")
        for episode in character.episode {
            print(episode)
        }
        
        print("URL: \(character.url)")
        print("Created: \(character.created)")
    }
}
