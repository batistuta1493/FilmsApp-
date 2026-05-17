import UIKit

class SingleBackdropViewController: UIViewController {
    
    enum CellIdentifiers: String {
        case cell
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var fullPicGalleryCollection: UICollectionView!
    
    var selectedItem: Int?
    var film: Film?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTitleLabel(with: selectedItem)
        setupDelegates()
        registerCells()
        showSelectedItem()
    }
    
    // MARK: - Private methods
    private func setupTitleLabel(with selectedItem: Int?) {
        guard let selectedItem = selectedItem,
        let film = film else {
            titleLabel.text = ""
            return
        }
        
        titleLabel.text = "\(selectedItem + 1)/\(film.screenshots.count)"
    }
    
    private func setupDelegates() {
        fullPicGalleryCollection.dataSource = self
        fullPicGalleryCollection.delegate = self
    }
    
    private func registerCells() {
        let nib = UINib(nibName: String(describing: SingleScreenShotCollectionViewCell.self), bundle: nil)
        fullPicGalleryCollection.register(nib, forCellWithReuseIdentifier: CellIdentifiers.cell.rawValue)
    }
    
    private func showSelectedItem() {
        guard let selectedItem = self.selectedItem else { return }
        let indexPath = IndexPath(item: selectedItem, section: .zero)
        fullPicGalleryCollection.scrollToItem(at: indexPath, at: .right, animated: false)
        fullPicGalleryCollection.layoutSubviews()
    }
}

// MARK: - UICollectionViewDataSource
extension SingleBackdropViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let film = film else { return .zero }
        
        return film.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = fullPicGalleryCollection.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.cell.rawValue, for: indexPath) as? SingleScreenShotCollectionViewCell,
        let film = film else {
            return UICollectionViewCell()
        }
        
        cell.imagePath = film.screenshots[indexPath.row]
        
        return cell
    }
}

// MARK: - CollectionView DelegateFlowLayout
extension SingleBackdropViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frameSize = collectionView.frame.size
        return CGSize(width: frameSize.width - 10, height: frameSize.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

// MARK: - CollectionView's Scroll view Delegate
extension SingleBackdropViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = fullPicGalleryCollection.contentOffset
        visibleRect.size = fullPicGalleryCollection.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = fullPicGalleryCollection.indexPathForItem(at: visiblePoint) else { return }
        setupTitleLabel(with: indexPath.row)
    }
}
