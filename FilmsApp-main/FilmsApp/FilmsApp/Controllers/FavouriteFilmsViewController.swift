import UIKit

class FavoriteFilmsViewController: UIViewController {
    
    enum Identifiers: String {
        case DetailFilmViewControllerID
    }
    
    @IBOutlet private weak var favoriteFilmsCollectionView: UICollectionView!
    @IBOutlet private weak var updateButton: UIBarButtonItem!
    
    let model = Core.model
    private var filmSelectedToRemoveFromLikedFilmsIDs: [Int] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBackButton()
        setupDelegates()
        registerCells()
        reloadCollectionViewData()
    }
    
    // MARK: - Actions
    @IBAction func updateButtonPressed(_ sender: UIBarButtonItem) {
        guard !filmSelectedToRemoveFromLikedFilmsIDs.isEmpty else { return }
        
        removeSelectedFilmsFromLikedFilms()
        reloadCollectionViewData()
    }
    
    @objc private func leftBarButtonAction() {
        guard !filmSelectedToRemoveFromLikedFilmsIDs.isEmpty else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        showAlert(title: "Warning", message: "All selected items will be removed from liked films!") {
            self.dismiss(animated: true)
            self.removeSelectedFilmsFromLikedFilms()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Private Methods
    private func removeSelectedFilmsFromLikedFilms() {
        for id in filmSelectedToRemoveFromLikedFilmsIDs {
            model.removeFromLikedBy(id: id)
        }
        filmSelectedToRemoveFromLikedFilmsIDs = []
    }
    
    private func setupNavigationBackButton() {
        navigationItem.hidesBackButton = true
        let navBackButton = UIBarButtonItem(title: "FilmsApp",
                                            style: UIBarButtonItem.Style.plain,
                                            target: self,
                                            action: #selector(leftBarButtonAction))
        navigationItem.leftBarButtonItem = navBackButton
    }
    
    private func showAlert(title: String, message: String?, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in completionHandler() }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(ok)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupDelegates() {
        favoriteFilmsCollectionView.delegate = self
        favoriteFilmsCollectionView.dataSource = self
    }
    
    private func registerCells() {
        let xibFavCell = UINib(nibName: String(describing: FavoriteFilmViewCell.self), bundle: nil)
        favoriteFilmsCollectionView.register(xibFavCell, forCellWithReuseIdentifier: String(describing: FavoriteFilmViewCell.self))
    }
    
    private func reloadCollectionViewData() {
        DispatchQueue.main.async {
            self.favoriteFilmsCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteFilmsViewController:  UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.likedFilms?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = favoriteFilmsCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FavoriteFilmViewCell.self), for: indexPath) as? FavoriteFilmViewCell,
              let likedFilm = model.likedFilms?[indexPath.item] else {
            return UICollectionViewCell()
        }
        
        cell.likedFilmViewCellDelegate = self
        
        var film = Film(from: likedFilm)
        film.isSelectedToRemoveFromLikedFilms = filmSelectedToRemoveFromLikedFilmsIDs.contains(film.id)
        cell.likedFilm = film
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension FavoriteFilmsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let destinationVC = storyboard?.instantiateViewController(withIdentifier: Identifiers.DetailFilmViewControllerID.rawValue) as? DetailFilmViewController else { return }
        
        if filmSelectedToRemoveFromLikedFilmsIDs.isEmpty {
            showLikedFilmSelectedAt(indexPath: indexPath, in: destinationVC)
        } else {
            showAlert(title: "Warning", message: "All recently selected items will be unselected!") {
                self.dismiss(animated: true)
                self.showLikedFilmSelectedAt(indexPath: indexPath, in: destinationVC)
                self.filmSelectedToRemoveFromLikedFilmsIDs = []
                self.reloadCollectionViewData()
            }
        }
    }
    
    private func showLikedFilmSelectedAt(indexPath: IndexPath, in destinationVC: DetailFilmViewController) {
        guard let selectedFilm = model.likedFilms?[indexPath.row] else { return }
        let film = Film(from: selectedFilm)
        destinationVC.film = film
        destinationVC.shouldHideLikeButton = true
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - LikedFilmViewCellDelegate
extension FavoriteFilmsViewController: LikedFilmViewCellDelegate {
    func deleteButtonDidTapOnFilmWith(id: Int) {
        
        if let index = filmSelectedToRemoveFromLikedFilmsIDs.firstIndex(of: id) {
            filmSelectedToRemoveFromLikedFilmsIDs.remove(at: index)
        } else {
            filmSelectedToRemoveFromLikedFilmsIDs.append(id)
        }
        
//        print("🟢 filmsSelectedToRemoveFromLikedFilms : \(filmSelectedToRemoveFromLikedFilmsIDs)")
        reloadCollectionViewData()
    }
}
