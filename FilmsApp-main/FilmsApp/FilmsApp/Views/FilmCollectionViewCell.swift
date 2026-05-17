import UIKit

class FilmCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var filmTitleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var film: Film? {
        didSet {
            guard let film = self.film,
                  let url = URL(string: Constants.urlBase + film.pictureStringURL) else {
                return
            }
            
            Core.dataProvider.downloadImage(url: url) { image in
                self.posterImageView.image = image
            }
            
            filmTitleLabel.text = film.filmTitle
            yearLabel.text = String(film.releaseYear)
            ratingLabel.text = String(film.filmRating)
            
            backgroundColor = .backgroundFilmCell
        }
    }
}
