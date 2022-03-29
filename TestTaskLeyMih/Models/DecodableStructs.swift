import Foundation
import UIKit

struct ApiInfo: Decodable {
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?
}

struct Character: Decodable, Hashable {
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: chLocation
    let location: chLocation
    let image: URL
    let episode: [URL]
    let url: URL
    let created: String
}

struct RawData<T: Decodable>: Decodable {
    let info: ApiInfo
    let results: [T]
}

struct chLocation: Decodable {
    let name: String
    let url: String
}

struct Location: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [URL]
    let url: String
    let created: String
}
