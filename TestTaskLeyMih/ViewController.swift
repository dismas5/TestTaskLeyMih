import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let parser = DataParser(link: "https://rickandmortyapi.com/api/character/", pages: 42)
    
    var loadingView: LoadingBarView?
    var characterToSegue: Character?
    var characters: [Character] = []
    var copiedCharacters: [Character] = []
    var isLoading: Bool = false
    var images = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadData()
    }
    
    func loadData() {
        //idk what does this line mean but without it characters upload slowier
        collectionView.collectionViewLayout.invalidateLayout()
        
        parser.parseData()
        sleep(1)
        characters = parser.getCharacters()
        copiedCharacters = characters

        for i in 0...20 {
            print("Picture \(i) was loaded")
            let data = try? Data(contentsOf: characters[i].image)
            self.images.append(UIImage(data: data!))
        }
        self.collectionView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.characters.removeAll()
        
        if (searchBar.text!.isEmpty) {
            self.characters = self.copiedCharacters
            self.collectionView.reloadData()
            return
        }
        
        for character in copiedCharacters {
            if (character.name.lowercased().contains(searchBar.text!.lowercased())) {
                self.characters.append(character)
            }
        }
        self.collectionView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segue" else {
            print("No segue found")
            return
        }
        guard let destination = segue.destination as? CharacterScreen else {
            print("No destination found")
            return
        }
        if characterToSegue != nil {
            destination.character = characterToSegue
        }
    }
}



extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //This is required to get index path and transfer picture to another screen
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath) as? CollectionViewCell) != nil {
            characterToSegue = characters[indexPath.item]
        }
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    //This is required for initialising top and bottom Reuseable sells
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch(kind) {
        case UICollectionView.elementKindSectionHeader:
            let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
            return searchView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingView", for: indexPath) as! LoadingBarView
            footerView.backgroundColor = UIColor.cyan
            loadingView = footerView
            loadingView?.backgroundColor = UIColor.clear
            return footerView
        
        default:
            return UICollectionReusableView()
        }
    }
    
    //This is required to get amount of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    //This activates when you see some element
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }

    //This activates when you stop seeing any element
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    //This is required to init cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let character = characters[indexPath.item]
        
        cell.characterImageView.image = images[indexPath.item]
        cell.characterLabel.text = character.name
        cell.idLabel.text = String(character.id)
        
        var color: UIColor = UIColor.systemGray
        switch(character.status) {
        case "Dead":
            color = UIColor.systemRed
        case "Alive":
            color = UIColor.systemGreen
        default:
            break
        }
        
        cell.backgroundColor = color
        cell.idLabel.backgroundColor = color
        cell.layer.cornerRadius = 5
        return cell
    }
    
    //This is required for setting size of footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.width, height: 60)
        }
    }
    
    //This activates before adding a cell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == images.count - 1 && !self.isLoading {
            self.isLoading = true
            let start = images.count
            let end = start + 20
            
            DispatchQueue.global().async {
                for i in start...end {
                    print("Picture \(i) was loaded")
                    let data = try? Data(contentsOf: self.characters[i].image)
                    self.images.append(UIImage(data: data!))
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
}
