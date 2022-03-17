import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let parser = DataParser(link: "https://rickandmortyapi.com/api/character/", pages: 42)
    
    var loadingView: LoadingBarView?
    var characterToSegue: Character?
    var characters: [Character] = []
    var copiedCharacters: [Character] = []
    var isHidden: Bool = false
    var images: [Character: UIImage] = [:]
    var loadedImages: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //idk what does this line mean but without it characters upload slowier
        collectionView.collectionViewLayout.invalidateLayout()
        parser.parseData()
        sleep(1)
        characters = parser.getCharacters()
        copiedCharacters = characters

        loadData()
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
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text!.isEmpty) {
            self.characters = self.copiedCharacters
            self.collectionView.reloadData()
            return
        }
        
        self.characters.removeAll()
        loadedImages = 0
        
        let searchBarText = searchBar.text!.components(separatedBy: ":")
        
        for character in copiedCharacters {
            if searchBarText.count <= 1 {
                if (character.name.lowercased().contains(searchBarText[0].lowercased())) {
                    self.characters.append(character)
                }
                continue
            }
            let searchValue = searchBarText[1].lowercased()
            switch searchBarText[0].lowercased() {
            case "name":
                if character.name.lowercased().contains(searchValue) {
                    self.characters.append(character)
                }
            case "status":
                if character.status.lowercased().contains(searchValue) {
                    self.characters.append(character)
                }
            case "species":
                if character.species.lowercased().contains(searchValue) {
                    self.characters.append(character)
                }
            case "type":
                if character.type.lowercased().contains(searchValue) {
                    self.characters.append(character)
                }
            case "gender":
                if character.gender.lowercased() == searchValue {
                    self.characters.append(character)
                }
            case "created":
                if character.created.lowercased().contains(searchValue) {
                    self.characters.append(character)
                }
            default:
                break
            }
        }
        loadData()
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
            destination.image = images[characterToSegue!]
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
        if characters.count == copiedCharacters.count {
            return images.count
        }
        return loadedImages
    }
    
    //This activates when you see a reusable view
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }

    //This activates when you stop seeing a reusable view
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    //This is required to init cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let character = characters[indexPath.item]
        
        cell.characterImageView.image = images[character]
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
        if self.isHidden {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.width, height: 60)
        }
    }
    
    //This activates before adding a cell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let borderToUpload: Int = (characters == copiedCharacters ? images.count : loadedImages) - 1
//        print(indexPath.item, loadedImages, characters.count)
        if (indexPath.item == borderToUpload) && !self.isHidden {
            var i = indexPath.item
            let end = i + 21
            
            DispatchQueue.global().async { [self] in
                while i <= end && i < characters.count {
                    print("Pic \(i) with id \(characters[i].id)")
                    let data = try? Data(contentsOf: characters[i].image)
                    images[characters[i]] = UIImage(data: data!)
                    
                    i += 1
                }
                DispatchQueue.main.async {
                    update(i)
                }
            }
        }
    }
}
