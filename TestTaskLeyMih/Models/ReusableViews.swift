import UIKit

class SearchBarView: UICollectionReusableView {
    @IBOutlet weak var searchBar: UISearchBar!
}

class LoadingBarView: UICollectionReusableView {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
}

extension ViewController {
    //This activates when you see a reusable view
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }

    //This activates when you stop seeing a reusable view
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
    //This is required for initialising top and bottom Reuseable sells
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch(kind) {
        case UICollectionView.elementKindSectionHeader:
            let searchView: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SearchBar", for: indexPath)
            return searchView
            
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingView", for: indexPath) as! LoadingBarView
            footerView.backgroundColor = UIColor.cyan
            loadingView = footerView
            loadingView?.backgroundColor = UIColor.clear
            return footerView
        
        default:
            return UICollectionReusableView()
        }
    }
    
    //This is required for setting size of footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isHidden {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.width, height: 60)
        }
    }
}
