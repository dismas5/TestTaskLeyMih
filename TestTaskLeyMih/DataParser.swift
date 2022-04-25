import Foundation

struct RawData<T: Decodable>: Decodable {
    let info: ApiInfo
    let results: [T]
}

class DataParser<T: Decodable> {
    
    init(link: String) {
        url = URL(string: link)!
    }
    
    init(_url: URL) {
        url = _url
    }
    
    var result = [T]()
    private var url: URL
    
    func parseData(completion: @escaping () -> Void) {
        func download(url: URL) {
            self.download(from: url) { newURL in
                continueDownload(newURL: newURL)
            }
        }
        
        func continueDownload(newURL: URL?) {
            guard let newURL = newURL else {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            download(url: newURL)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            download(url: self.url)
        }
    }
    
    private func download(from url: URL, completion: @escaping (URL?) -> Void) {
        URLSession.shared.dataTask(with: url) { [self] data, _, error in
            if let data = data {
                do {
                    let rawData = try JSONDecoder().decode(RawData<T>.self, from: data)
                    result += rawData.results
                    completion(rawData.info.next)
                } catch {
                    print("Error: \(error)")
                }
            }
        }.resume()
    }
}
