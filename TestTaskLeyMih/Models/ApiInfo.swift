import Foundation

struct ApiInfo: Decodable {
    let count: Int
    let pages: Int
    let next: URL?
    let prev: URL?
}
