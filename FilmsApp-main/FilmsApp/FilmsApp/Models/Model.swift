import UIKit
import RealmSwift

class Model {
    
    let realm = try? Realm()
    
    var isSortedAscending: Bool = false
    
    var films: Results<FilmObject>? {
        
        let allFilmsFromDB = realm?.objects(FilmObject.self)
        let filmsSorted = allFilmsFromDB?.sorted(byKeyPath: "filmRating", ascending: isSortedAscending)
        
        guard let searchText = searchTextValue else {
            return filmsSorted
        }
        let predicate = NSPredicate(format: "filmTitle CONTAINS [c]%@", searchText)
        return filmsSorted?.filter(predicate)
    }
    
    var likedFilms: Results<LikedFilmObject>? {
        return realm?.objects(LikedFilmObject.self)
    }
    
    private var searchTextValue: String?
    
    // MARK: - Public Methods
    func search(searchTextValue: String?) {
        self.searchTextValue = searchTextValue
    }
    
    func cancelSearch() {
        self.searchTextValue = nil
    }
    
    func changeSortDirection() {
        isSortedAscending = !isSortedAscending
    }
    
    func updateLikeForFilmWith(id: Int) {
        guard let film = realm?.object(ofType: FilmObject.self, forPrimaryKey: id) else { return }
        
        do {
            try realm?.write ({
                film.isLikedByUser = !film.isLikedByUser
                if film.isLikedByUser {
                    addToLikedFilms(film: film)
                } else {
                    removeFromLikedFilmWith(id: film.id)
                }
            })
        } catch {
            print("🔴 Can't update Like status for film due error: \(error)")
        }
    }
    
    
    func removeFromLikedBy(id: Int) {
        guard let film = realm?.object(ofType: LikedFilmObject.self, forPrimaryKey: id) else { return }
        
        do {
            try realm?.write ({
                removeFromLikedFilmWith(id: film.id)
            })
        } catch {
            print("🔴 Can't Remove Liked film due error: \(error)")
        }
    }
    
    func setupLikedForFilmWith(id: Int) {
        guard (realm?.object(ofType: LikedFilmObject.self, forPrimaryKey: id)) != nil else { return }
        
        if let film = realm?.object(ofType: FilmObject.self, forPrimaryKey: id) {
            do {
                try realm?.write ({
                    film.isLikedByUser = true
                })
            } catch {
                print("🔴 Can't setup Like status for film due error: \(error)")
            }
        }
    }
    
    func isInLikedFilmsBy(id: Int) -> Bool {
        return realm?.object(ofType: LikedFilmObject.self, forPrimaryKey: id) != nil
    }
    
    // MARK: - Private Methods
    private func addToLikedFilms(film: FilmObject) {
        let newLikedFilm = LikedFilmObject()
        newLikedFilm.id = film.id
        newLikedFilm.filmPic = film.filmPic
        newLikedFilm.filmTitle = film.filmTitle
        newLikedFilm.about = film.about
        newLikedFilm.releaseYear = film.releaseYear
        newLikedFilm.filmRating = film.filmRating
        newLikedFilm.isLikedByUser = true
        
        realm?.add(newLikedFilm, update: .all)
    }
    
    private func removeFromLikedFilmWith(id: Int) {
        guard let likedFilm = realm?.object(ofType: LikedFilmObject.self, forPrimaryKey: id) else { return }
        realm?.delete(likedFilm)
    }
}
