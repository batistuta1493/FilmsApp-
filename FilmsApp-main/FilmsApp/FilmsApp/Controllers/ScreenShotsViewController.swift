import UIKit

class ScreenShotsViewController: UIViewController {
    
    enum CellIdentifiers: String {
        case cell
    }
    
    enum Identifiers: String {
        case SingleBackdropViewControllerID
    }
    
    @IBOutlet private weak var picsNumberLabel: UILabel!
    @IBOutlet private weak var filmPicsCollectionView: UICollectionView!
    
    var film: Film?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegates()
        registerCells()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        guard let film = film else { return }
        
        picsNumberLabel.text = "\(film.screenshots.count) backdrops"
    }
    
    private func setupDelegates() {
        filmPicsCollectionView.dataSource = self
        filmPicsCollectionView.delegate = self
    }
    
    private func registerCells() {
        let nib = UINib(nibName: String(describing: BigScreenShotCollectionViewCell.self), bundle: nil)
        filmPicsCollectionView.register(nib, forCellWithReuseIdentifier: CellIdentifiers.cell.rawValue)
    }
}

// MARK: - UICollectionViewDataSource
extension ScreenShotsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let film = film else { return .zero }
        
        return film.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = filmPicsCollectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.cell.rawValue, for: indexPath) as? BigScreenShotCollectionViewCell,
              let film = film else {
            return UICollectionViewCell()
        }
        cell.imagePath = film.screenshots[indexPath.row]
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ScreenShotsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let destinationVC = storyboard?.instantiateViewController(withIdentifier: Identifiers.SingleBackdropViewControllerID.rawValue) as? SingleBackdropViewController else {
            return
        }
        
        destinationVC.selectedItem = indexPath.row
        destinationVC.film = film
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension ScreenShotsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = 320
        let height = width * 0.625
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
