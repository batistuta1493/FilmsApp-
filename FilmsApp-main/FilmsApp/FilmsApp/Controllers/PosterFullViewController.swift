import UIKit

final class PosterFullViewController: UIViewController {
    
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var fullPosterImageView: UIImageView!
    
    var posterImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let posterImage = self.posterImage else { return }
        fullPosterImageView.image = posterImage
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
