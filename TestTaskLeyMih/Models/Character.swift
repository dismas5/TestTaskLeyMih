import Foundation

struct Character: Decodable {
    enum Status: String, Decodable {
        case dead = "Dead"
        case alive = "Alive"
        case unknown
    }
    
    enum Gender: String, Decodable {
        case male = "Male"
        case female = "Female"
        case genderless = "Genderless"
        case unknown
    }
    
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin: CharacterLocation
    let location: CharacterLocation
    let image: URL
    let episode: [URL]
    let url: URL
    let created: String
}

extension Character: Equatable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Character: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
