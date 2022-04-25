import UIKit

class LoadingBarView: UICollectionReusableView {
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func endLoading() {
        activityIndicator.stopAnimating()
    }
}
