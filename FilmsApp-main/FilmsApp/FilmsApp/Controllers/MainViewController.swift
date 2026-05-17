import UIKit

class MainViewController: UIViewController {
    
    enum Identifiers: String {
        case DetailFilmViewControllerID
    }
    
    @IBOutlet private weak var mainCollectionView: UICollectionView!
    @IBOutlet private weak var sortButton: UIBarButtonItem!
    
    private let model = Core.model
    
    private var searchController = UISearchController()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Find Your Film"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        registerCells()
        setupSortButton()
        
        DispatchQueue.main.async {
            Core.urlService.dataRequest(request: .popular)
        }
        
        mainCollectionView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func sortButtonDidTap(_ sender: UIBarButtonItem) {
        model.changeSortDirection()
        setupSortButton()
        reloadCollectionViewData()
    }
    
    // MARK: - Private Methods
    private func registerCells() {
        let xibCell = UINib(nibName: String(describing: FilmCollectionViewCell.self), bundle: nil)
        mainCollectionView.register(xibCell, forCellWithReuseIdentifier: String(describing: FilmCollectionViewCell.self))
    }
    
    private func setupSortButton() {
        let sortButtonImageName = model.isSortedAscending ? "arrow.up" : "arrow.down"
        sortButton.image = UIImage(systemName: sortButtonImageName)
    }
    
    private func reloadCollectionViewData() {
        DispatchQueue.main.async {
            self.mainCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.films?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FilmCollectionViewCell.self), for: indexPath) as? FilmCollectionViewCell,
              let film = model.films?[indexPath.row] else {
            return UICollectionViewCell()
        }
        
        cell.film = Film(from: film)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let destinationVC = storyboard?.instantiateViewController(withIdentifier: Identifiers.DetailFilmViewControllerID.rawValue) as? DetailFilmViewController,
              let selectedFilmId = model.films?[indexPath.row].id else {
            return
        }
        
        model.setupLikedForFilmWith(id: selectedFilmId)
        
        guard let film = model.films?[indexPath.row] else { return }
        destinationVC.film = Film(from: film)
                
        Core.urlService.getBackdropsForFilmBy(id: film.id)
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - SearchBar Methods
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count != .zero {
            model.search(searchTextValue: searchText)
        } else {
            model.cancelSearch()
        }
        reloadCollectionViewData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
        model.cancelSearch()
        reloadCollectionViewData()
    }
}
