import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let characterParser = DataParser<Character>(link: "https://rickandmortyapi.com/api/character/")
    let locationParser = DataParser<Location>(link: "https://rickandmortyapi.com/api/location")
    
    var loadingView: LoadingBarView?
    var characterToSegue: Character?
    var characters: [Character] = []
    var copiedCharacters: [Character] = []
    var isHidden: Bool = false
    var images: [Character: UIImage] = [:]
    var loadedImages: Int = 0
    
    override func loadView() {
        super.loadView()
        characterParser.parseData()
        characters = characterParser.getCharacters()
        copiedCharacters = characters
        locationParser.parseData()
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //idk what does this line mean but without it characters upload slowier
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func loadData() {
        var i: Int = 0
        while i <= 20 && i < characters.count {
            print("Pic \(i): \(characters[i].name)")
            let data = try? Data(contentsOf: characters[i].image)
            self.images[characters[i]] = UIImage(data: data!)
            i += 1
        }

        update(i)
    }
    
    func update(_ i: Int) {
        isHidden = i >= characters.count
        loadedImages = i
        collectionView.reloadData()
    }
}
