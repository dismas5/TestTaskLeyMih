import UIKit

extension ViewController {
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
            case "origin":
                if character.origin.name.lowercased().contains(searchValue) {
                    self.characters.append(character)
                }
            case "location":
                if character.location.name.lowercased().contains(searchValue) {
                    self.characters.append(character)
                }
            default:
                break
            }
        }
        loadData()
    }
}
