// Popular:
// https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1

// Latest:
// https://api.themoviedb.org/3/movie/latest?api_key=<<api_key>>&language=en-US

// Now Playing:
// https://api.themoviedb.org/3/movie/now_playing?api_key=<<api_key>>&language=en-US&page=1

// Top Rated:
// https://api.themoviedb.org/3/movie/top_rated?api_key=<<api_key>>&language=en-US&page=1

// Upcoming:
// https://api.themoviedb.org/3/movie/upcoming?api_key=<<api_key>>&language=en-US&page=1

import UIKit

enum ApiRequest: String {
    case latest = "latest"
    case popular = "popular"
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case upcoming = "upcoming"
    
    var urlEnd: String {
        return self.rawValue == "latest" ? "" : "&page=1"
    }
}

class URLService {
    
    let apiKey: String = "a7e7734795f96137ff3605cc57a01ddb"
    let urlBase: String = "https://api.themoviedb.org/3/movie/"
    let session = URLSession.shared
    let parser = JSONParsingService()
    
    func dataRequest(request: ApiRequest) {
        
        let urlString = "\(urlBase)\(request.rawValue)?api_key=\(apiKey)&language=en-US\(request.urlEnd)"
        
        guard let apiURL: URL = URL(string: urlString) else { return }
        
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let unwrData = data,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                return
            }
            self.parser.parseMovieListJSON(parseData: unwrData, parseError: error)
        }
        task.resume()
    }
    
    // https://api.themoviedb.org/3/movie/{movie_id}/images?api_key=<<api_key>>
    func getBackdropsForFilmBy(id: Int) {
        
        let idString = String(id)
        
        let urlString = "\(urlBase)\(idString)/images?api_key=\(apiKey)"
        
        guard let apiURL: URL = URL(string: urlString) else { return }
        
        let task = session.dataTask(with: apiURL) { data, response, error in
            guard let unwrData = data,
                  (response as? HTTPURLResponse)?.statusCode == 200,
                  error == nil else {
                return
            }
            print("🟢🟢🟢 UnwrData: \(unwrData)")
            self.parser.parseFilmDataJSON(parseData: unwrData, parseError: error)
        }
        task.resume()
    }
}
