import Foundation
import UIKit

class CharacterScreen: UIViewController {
    
    @IBOutlet weak var CharacterPicture: UIImageView!
    @IBOutlet weak var CharacterName: UILabel!
    @IBOutlet weak var IdLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var SpeciesLabel: UILabel!
    @IBOutlet weak var TypeLabel: UILabel!
    @IBOutlet weak var GenderLabel: UILabel!
    @IBOutlet weak var CreatedLabel: UILabel!
    
    var character: Character?
//    var image: UIImage = UIImage(named: "TestImg3")!
    
    
    override func viewDidLoad() {
        if character != nil {
            CharacterPicture.image = character?.getImagefromURL()
            CharacterName.text = character?.name
            IdLabel.text! += String(character!.id)
            StatusLabel.text! += String(character!.status)
            SpeciesLabel.text! += String(character!.species)
            TypeLabel.text! += String(character!.type)
            GenderLabel.text! += String(character!.gender)
            CreatedLabel.text! += String(character!.created)

//            print("List of episodes:")
//            for episode in character.episode {
//                print(episode)
//            }
//
        }
        
    }
    
}
