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
    @IBOutlet weak var episodesLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    var character: Character?
    var image: UIImage?
    
    override func viewDidLoad() {
        if let character = character {
            if let image = image {
                characterPicture.image = image
            }
            characterName.text = character.name
            idLabel.text! += String(character.id)
            statusLabel.text! += character.status
            speciesLabel.text! += character.species
            
            if character.type == "" {
                typeLabel.isHidden = true
            } else {
                typeLabel.text! += character.type
            }
            
            genderLabel.text! += character.gender
            
            expandButton.addTarget(self, action: #selector(expandEpisodes), for: .touchDown)
            for episode in character.episode {
                episodesLabel.text! += "\(episode)\n"
            }
            
            createdLabel.text! += character.created
        }
        
    }
    
    @objc func expandEpisodes() {
        episodesLabel.isHidden = !episodesLabel.isHidden
    }
}