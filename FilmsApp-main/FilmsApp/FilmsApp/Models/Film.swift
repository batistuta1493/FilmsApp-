import Foundation
import RealmSwift

struct Film {
    let id: Int
    let pictureStringURL: String
    let filmTitle: String
    let about: String
    let releaseYear: Int
    let filmRating: Double
    let screenshots: [String]
    let isLikedByUser: Bool
    var isSelectedToRemoveFromLikedFilms: Bool = false
    
    init(from film: ParentFilmObject) {
        id = film.id
        pictureStringURL = film.filmPic
        filmTitle = film.filmTitle
        about = film.about
        releaseYear = film.releaseYear
        filmRating = film.filmRating
        screenshots = Array(film.screenshots)
        isLikedByUser = film.isLikedByUser
    }
}

class ParentFilmObject: Object {
    @Persisted var id: Int = 0
    @Persisted var filmPic: String = ""
    @Persisted var filmTitle: String = ""
    @Persisted var about: String = ""
    @Persisted var releaseYear: Int = 0
    @Persisted var filmRating: Double = 0.0
    @Persisted var screenshots: List<String> = List<String>()
    @Persisted var isLikedByUser: Bool = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class FilmObject: ParentFilmObject {
}

class LikedFilmObject: ParentFilmObject {
}
