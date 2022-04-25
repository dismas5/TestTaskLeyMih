import UIKit

final class CharacterCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var idLabel: UILabel!
    @IBOutlet private var characterImageView: UIImageView!
    @IBOutlet private var characterLabel: UILabel!
    
    func configure(with character: Character, images: [Character: UIImage]) {
        characterImageView.image = images[character]
        characterLabel.text = character.name
        idLabel.text = String(character.id)
        
        var color: UIColor = UIColor.systemGray
        switch(character.status) {
        case .dead:
            color = UIColor.systemRed
        case .alive:
            color = UIColor.systemGreen
        default:
            break
        }
        
        backgroundColor = color
        idLabel.backgroundColor = color
        layer.cornerRadius = 5
    }
}
