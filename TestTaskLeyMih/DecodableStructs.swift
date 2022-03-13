import Foundation
import UIKit

struct ApiInfo: Decodable {
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?
}

struct Character: Decodable {
    //TODO: Add origin and location
    
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: URL
    let episode: [URL]
    let url: URL
    let created: String
    
    func getImagefromURL() -> UIImage? {
        if let data = try? Data(contentsOf: self.image) {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return nil
    }
}

struct RawData: Decodable {
    let info: ApiInfo
    let results: [Character]
}
