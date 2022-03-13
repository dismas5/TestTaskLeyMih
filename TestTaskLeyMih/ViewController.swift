import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!

    let parser = DataParser()
    let characterScreen = CharacterScreen()
    var characterToSegue: Character?
    
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let character = parser.getCharacterById(indexPath.item)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath) as? CollectionViewCell) != nil {
            characterToSegue = parser.getCharacterById(indexPath.item)
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
