import UIKit

protocol LikedFilmViewCellDelegate: AnyObject {
    func deleteButtonDidTapOnFilmWith(id: Int)
}

class FavoriteFilmViewCell: UICollectionViewCell {
    
    @IBOutlet weak var favoritePosterImageView: UIImageView!
    @IBOutlet weak var favoriteFilmTitleLabel: UILabel!
    @IBOutlet weak var favoriteYearLabel: UILabel!
    @IBOutlet weak var favoriteRatingLabel: UILabel!
    
    // MARK: - Properties
    
    weak var likedFilmViewCellDelegate: LikedFilmViewCellDelegate?
    
    var likedFilm: Film? {
        didSet {
            guard let likedFilm = self.likedFilm,
                  let url = URL(string: Constants.urlBase + likedFilm.pictureStringURL) else {
                return
            }
            
            Core.dataProvider.downloadImage(url: url) { image in
                self.favoritePosterImageView.image = image
            }
            
            favoriteFilmTitleLabel.text = likedFilm.filmTitle
            favoriteYearLabel.text = String(likedFilm.releaseYear)
            favoriteRatingLabel.text = String(likedFilm.filmRating)
            
            let isSelected = likedFilm.isSelectedToRemoveFromLikedFilms
            backgroundColor = isSelected ? .backgroundSelectedCell : .backgroundLikedFilmCell
        }
    }
    
    // MARK: - Actions
    @IBAction private func deleteButtonDidTap(_ sender: UIButton) {
        guard let likedFilm = self.likedFilm else { return }
        likedFilmViewCellDelegate?.deleteButtonDidTapOnFilmWith(id: likedFilm.id)
    }
}
