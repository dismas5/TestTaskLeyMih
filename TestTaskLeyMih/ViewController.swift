import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    let parser = DataParser(link: "https://rickandmortyapi.com/api/character/", pages: 42)
    let characterScreen = CharacterScreen()
    
    var characterToSegue: Character?
    var characters: [Character] = []
    var copiedCharacters: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parser.parseData()
        sleep(1)
        characters = parser.getCharacters()
        copiedCharacters = characters
        //TODO: Make it run sync, without sleep(1)
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let character = characters[indexPath.item]
        
        if let image = character.getImagefromURL() {
            print("Character \(indexPath.item) is displayed!")
            cell.CharacterImageView.image = image
        }
        
        cell.CharacterLabel.text = character.name
        cell.IdLabel.text = String(character.id)
        
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
        cell.IdLabel.backgroundColor = color
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
        
        return searchView
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath) as? CollectionViewCell) != nil {
            characterToSegue = characters[indexPath.item]
        }
        if characters[indexPath.item].id == 9 {
            collectionView.reloadData()
        }
        performSegue(withIdentifier: "segue", sender: self)
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
