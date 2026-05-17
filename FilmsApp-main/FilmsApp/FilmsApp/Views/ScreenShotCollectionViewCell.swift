import UIKit

class ScreenShotCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var screnshotImageView: UIImageView!
    
    var imagePath: String? {
        didSet {
            guard let imagePath = self.imagePath else { return }
            guard let url = URL(string: Constants.urlBase + imagePath) else { return }
            
            Core.dataProvider.downloadImage(url: url) { image in
                self.screnshotImageView.image = image
            }
        }
    }
}
