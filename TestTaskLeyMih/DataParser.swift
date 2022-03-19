import Foundation

class DataParser {
    
    init(link: String) {
        JsonLink = link
    }
    
    public var characters: [Character] = [Character]()
    private var pagesAmount: Int = 1
    private var JsonLink: String = ""
    
    func getCharacters() -> [Character] {
        return characters
    }
    
    func download(_ url: URL, _ i: Int, completion: @escaping (URL?)->()) {
        let sem = DispatchSemaphore(value: 0)
        var rawData: RawData?
        URLSession.shared.dataTask(with: url) { [self] data, _, error in
            defer { sem.signal() }
            if let data = data {
            do {
                rawData = try JSONDecoder().decode(RawData.self, from: data)
                characters += rawData!.results
                print("Page \(i) exported successfully!")
            } catch {
                print("Error: \(error)")
            }
            }
        }.resume()
        
        sem.wait(timeout: .distantFuture)
        completion(rawData!.info.next)
    }

    func parseData() {
        var url = URL(string: JsonLink)
        var page: Int = 1

        while url != nil {
            download(url!, page) { link in
                url = link
            }

            page += 1
        }
        print("Parsing is ready")
    }
}
