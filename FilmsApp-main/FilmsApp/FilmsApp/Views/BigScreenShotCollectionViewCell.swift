import UIKit

class BigScreenShotCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var screenshotImageView: UIImageView!
    
    var imagePath: String? {
        didSet {
            guard let imagePath = self.imagePath else { return }
            guard let url = URL(string: Constants.urlBase + imagePath) else { return }
            
            Core.dataProvider.downloadImage(url: url) { image in
                self.screenshotImageView.image = image
            }
            
            screenshotImageView.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0).cgColor
            screenshotImageView.layer.borderWidth = 2
        }
    }
}
