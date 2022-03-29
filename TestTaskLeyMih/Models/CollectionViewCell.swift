//
//  CollectionViewCell.swift
//  TestTaskLeyMih
//
//  Created by Dimasik on 10.03.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterLabel: UILabel!
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //This is required to get amount of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if characters.count == copiedCharacters.count {
            return images.count
        }
        return loadedImages
    }
    
    //This is required to init cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let character = characters[indexPath.item]
        
        cell.characterImageView.image = images[character]
        cell.characterLabel.text = character.name
        cell.idLabel.text = String(character.id)
        
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
        cell.idLabel.backgroundColor = color
        cell.layer.cornerRadius = 5
        return cell
    }
    
    //This activates before adding a cell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let borderToUpload: Int = (characters == copiedCharacters ? images.count : loadedImages) - 1
//        print(indexPath.item, loadedImages, characters.count)
        if (indexPath.item == borderToUpload) && !self.isHidden {
            var i = indexPath.item
            let end = i + 21
            
            DispatchQueue.global().async { [self] in
                while i <= end && i < characters.count {
                    print("Pic \(i): \(characters[i].name)")
                    let data = try? Data(contentsOf: characters[i].image)
                    images[characters[i]] = UIImage(data: data!)
                    
                    i += 1
                }
                DispatchQueue.main.async {
                    update(i)
                }
            }
        }
    }
}
