import Foundation

class DataParser<T: Decodable> {
    
    init(link: String) {
        url = URL(string: link)!
    }
    
    init(_url: URL) {
        url = _url
    }
    
    public var result: [T] = []
    private var pagesAmount: Int = 1
    private var url = URL(string: "")
    
    func getCharacters() -> [T] {
        return result
    }
    
    func download(_ i: Int) {
        let sem = DispatchSemaphore(value: 0)
        var rawData: RawData<T>?
        if let url = url {
            URLSession.shared.dataTask(with: url) { [self] data, _, error in
                defer { sem.signal() }
                if let data = data {
                    do {
                        rawData = try JSONDecoder().decode(RawData.self, from: data)
                        result += rawData!.results
                        print("Page \(i) exported successfully!")
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }.resume()
        }
        sem.wait(timeout: .distantFuture)
        url = rawData!.info.next
    }

    func parseData() {
        while url != nil {
            download(pagesAmount)
            pagesAmount += 1
        }
        print("Parsing is ready")
    }
}
