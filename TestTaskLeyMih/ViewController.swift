import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let parser = DataParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parser.parseData()
        sleep(1)
        //TODO: Make it run sync, without sleep(1)
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parser.getCharactersAmount()
    }
    
    @objc func UIGetCharacterInfo(_ sender: UIButton) {
        let characterId = sender.tag
        parser.getCharacterInfo(parser.getCharacterById(characterId))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        let character = parser.getCharacterById(indexPath.item)
        if let data = try? Data(contentsOf: character.image) {
        if let image = UIImage(data: data) {
            print("Character \(indexPath.item) is displayed!")
            cell.CharacterImageView.image = image
        }
        }
        
        cell.CharacterLabel.text = character.name
        cell.IdLabel.text = String(character.id)
        
        cell.ActionButton.tag = character.id - 1
        cell.ActionButton.addTarget(self, action: #selector(UIGetCharacterInfo(_:)), for: .touchUpInside)
        return cell
    }
}
