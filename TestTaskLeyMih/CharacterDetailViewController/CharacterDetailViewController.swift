import UIKit

final class CharacterDetailViewController: UIViewController {
    @IBOutlet private var characterPicture: UIImageView!
    @IBOutlet private var characterName: UILabel!
    @IBOutlet private var idLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var speciesLabel: UILabel!
    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var genderLabel: UILabel!
    @IBOutlet private var episodesLabel: UILabel!
    @IBOutlet private var createdLabel: UILabel!
    @IBOutlet private var expandButton: UIButton!
    
    var character: Character?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let character = character {
            if let image = image {
                characterPicture.image = image
            }
            characterName.text = character.name
            idLabel.text! += String(character.id)
            statusLabel.text! += character.status.rawValue
            speciesLabel.text! += character.species
            
            if character.type == "" {
                typeLabel.isHidden = true
            } else {
                typeLabel.text! += character.type
            }
            
            genderLabel.text! += character.gender.rawValue
            
            expandButton.addTarget(self, action: #selector(expandEpisodes), for: .touchDown)
            for episode in character.episode {
                episodesLabel.text! += "\(episode)\n"
            }
            
            createdLabel.text! += character.created
        }
        
    }
    
    @objc private func expandEpisodes() {
        episodesLabel.isHidden = !episodesLabel.isHidden
    }
}
