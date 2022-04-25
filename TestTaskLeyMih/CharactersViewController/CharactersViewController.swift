import UIKit

final class CharactersViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    
    private let characterParser = DataParser<Character>(link: "https://rickandmortyapi.com/api/character/")
    private let locationParser = DataParser<Location>(link: "https://rickandmortyapi.com/api/location")
    
    private var loadingView: LoadingBarView?
    private var characterToSegue: Character?
    private var characters = [Character]()
    private var copiedCharacters = [Character]()
    private var isHidden = false
    private var images = [Character: UIImage]()
    private var loadedImages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "CharacterCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CharacterCollectionViewCell")
        
        collectionView.register(UINib(nibName: "SearchBarView", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBarView")
        collectionView.register(UINib(nibName: "LoadingBarView", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadingBarView")
        
        characterParser.parseData { [weak self] in
            guard let self = self else { return }
            self.characters = self.characterParser.result
            self.copiedCharacters = self.characters
            self.collectionView.reloadData()
            self.loadData()
        }
        
        locationParser.parseData {}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segue" else {
            print("No segue found")
            return
        }
        guard let destination = segue.destination as? CharacterDetailViewController else {
            print("No destination found")
            return
        }
        if characterToSegue != nil {
            destination.character = characterToSegue
            destination.image = images[characterToSegue!]
        }
    }
    
    private func loadData() {
        var i: Int = 0
        while i <= 20 && i < characters.count {
            print("Pic \(i): \(characters[i].name)")
            let data = try? Data(contentsOf: characters[i].image)
            self.images[characters[i]] = UIImage(data: data!)
            i += 1
        }

        update(i)
    }
    
    private func update(_ i: Int) {
        isHidden = i >= characters.count
        loadedImages = i
        collectionView.reloadData()
    }
}

extension CharactersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if characters.count == copiedCharacters.count {
            return images.count
        }
        return loadedImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCollectionViewCell", for: indexPath) as! CharacterCollectionViewCell
        let character = characters[indexPath.item]
        cell.configure(with: character, images: images)
        return cell
    }
}

extension CharactersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath) as? CharacterCollectionViewCell) != nil {
            characterToSegue = characters[indexPath.item]
        }
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let borderToUpload: Int = (characters == copiedCharacters ? images.count : loadedImages) - 1
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
                    self.update(i)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.startLoading()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.endLoading()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch(kind) {
        case UICollectionView.elementKindSectionHeader:
            let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBarView", for: indexPath)
            return searchView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingBarView", for: indexPath) as! LoadingBarView
            footerView.backgroundColor = UIColor.cyan
            loadingView = footerView
            loadingView?.backgroundColor = UIColor.clear
            return footerView
        
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isHidden {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.width, height: 60)
        }
    }
}
