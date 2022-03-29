import UIKit

extension ViewController {

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
    
    //This is required to get index path and transfer picture to another screen
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath) as? CollectionViewCell) != nil {
            characterToSegue = characters[indexPath.item]
        }
        performSegue(withIdentifier: "segue", sender: self)
    }
    
}
