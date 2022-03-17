import Foundation
import UIKit

class CharacterScreen: UIViewController {
    
    @IBOutlet weak var characterPicture: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    var character: Character?
    var image: UIImage?
    
    override func viewDidLoad() {
        if character != nil {
            if let image = image {
                characterPicture.image = image
            }
            characterName.text = character?.name
            idLabel.text! += String(character!.id)
            statusLabel.text! += String(character!.status)
            speciesLabel.text! += String(character!.species)
            typeLabel.text! += String(character!.type)
            genderLabel.text! += String(character!.gender)
            createdLabel.text! += String(character!.created)

//            print("List of episodes:")
//            for episode in character.episode {
//                print(episode)
//            }
//
        }
        
    }
    
}
