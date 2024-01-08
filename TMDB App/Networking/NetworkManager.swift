//
//  NetworkManager.swift
//  TMDB App
//
// Created by Kim on 27.04.2023
// #DEVELOPMENT HELL on 07.12.2023

import Alamofire
import AVKit
import UIKit

class NetworkManager {
    
    var isRestartNeeded: Bool {
        requestToken == nil || sessionID == nil
    }
    
    private var requestToken: String? {
        get {
            UserDefaults.standard.value(forKey:Defaults.savedRequestToken) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Defaults.savedRequestToken)
        }
    }
    private var sessionID: String? {
        get {
            UserDefaults.standard.value(forKey:Defaults.savedSessionId) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Defaults.savedSessionId)
        }
    }
    
    private let apiKey = "15ec7b54d43e199ced41a6e461173cee"
    var accountInfo: AccountInfo?
    
    private init() { }
    
    static let shared = NetworkManager()
    
    func validateURLRequestWithRedirectLink(_ link: String) -> URLRequest? {
        guard let token = requestToken else {
            return nil
        }
        return URLRequest(url: URL(string: "https://www.themoviedb.org/authenticate/\(token)?redirect_to=\(link)")!)
    }
    
    func getRequestToken(_ callback: @escaping (Bool) -> () ) {
        
        let url = "https://api.themoviedb.org/3/authentication/token/new?api_key=15ec7b54d43e199ced41a6e461173cee"
        
        AF.request(url).responseDecodable(of: RequestTokenResponse.self) {
            response in
            
            switch response.result {
                
            case .success(let answer):
                print("Success with JSON: \(answer)")
                self.requestToken = answer.requestToken
                
                callback(true)
            case .failure(let error):
                print("Request failed with error: \(error)")
                callback(false)
            }
        }
    }
    
    func signInWithLogin(_ login: String = "",
                         password: String = "",
                         callback: @escaping (Bool) -> () ) {
        
        guard let requestToken = requestToken else { return }
        
        let url = "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=f77df0007f8c4910502f9e8ab6be462a"
        let params: [String: Any] = ["username": login,
                                     "password": password,
                                     "request_token": requestToken]
        AF.request(url, parameters: params).responseDecodable(of: RequestTokenResponse.self) {
            response in
            switch response.result {
                
            case .success(let answer):
                print("Answer for sign in: \(answer)")
                callback(true)
            case .failure(let error):
                print("Request failed with error: \(error)")
                callback(false)
            }
        }
        
    }
    
    //MARK: Creating a session_id
    func getSessionID(_ completion: @escaping (Bool) -> () ){
        
        print("REQUEST TOKEN -> \(requestToken!)")
        
        AF.request("https://api.themoviedb.org/3/authentication/session/new?api_key=15ec7b54d43e199ced41a6e461173cee", method: .post, parameters: ["request_token":NetworkManager.shared.requestToken!], encoding: JSONEncoding.default)
            .responseJSON { response in
                //                self.sessionID = response.result
                let result = response.result
                
                
                switch result {
                case .success(let value):
                    var myDictionary = [String: Any]()
                    if let responseDictionary = value as? [String: Any] {
                        myDictionary = responseDictionary
                        print(myDictionary)
                        
                        if let id = myDictionary["session_id"] as? String {
                            self.sessionID = id
                            print("001 = \(self.sessionID)")
                            completion(true)
                        } else {
                            completion(false)
                        }
                        
                    }
                case .failure(let error):
                    print("Ошибка: \(error.localizedDescription)")
                }
            }
        
    }
    
    
    func getAccountInfo(_ completion: @escaping (Bool) -> () ){
        let urlString = "https://api.themoviedb.org/3/account?="
        print("003 = \(sessionID)")
        let parameters: [String: String] = ["api_key": apiKey, "session_id": sessionID as! String]
        
        
        AF.request(urlString, method: .get, parameters: parameters).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                print("parameters = \(parameters)")
                
                if let responseDictionary = value as? [String: Any] {
                    
                    if let accountInfo = AccountInfo(dictionary: responseDictionary){
                        self.accountInfo = accountInfo
                        print("id = \(self.accountInfo?.id)")
                        completion(true)
                    } else {
                        print("Error: cannot find a username")
                        completion(false)
                    }
                }
                
            case .failure(_):
                print("Error with /account")
                completion(false)
            }
            
        }
    }
    
    func loadImageUsingAlamofire(from url: URL, completion: @escaping (UIImage?) -> Void) {
        AF.request(url).responseData { response in
            if let data = response.data {
                let image = UIImage(data: data)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    func getFavoriteMovies(_ completion: @escaping (FavouritesMoviesResponse?) -> ()){
        
        let parameters: [String: String] = ["account_id": String(accountInfo!.id)]
        
        let httpString = "https://api.themoviedb.org/3/account/" + String(accountInfo!.id) + "/favorite/movies?api_key="
        let bodyString = apiKey + "&session_id=" + sessionID! + "&language=en-US&sort_by=created_at.asc&page=1"
        let urlString = httpString + bodyString
        
//        let finalURLString = urlString + "&width=100" 
            
            AF.request(urlString, method: .get, parameters: parameters).responseJSON { [self] response in
                switch response.result {
                case .success(let value):
                    print("VALUE = \(value)")
                
                let decoder = JSONDecoder()
                
                if let jsonMovieResponse = try? decoder.decode(FavouritesMoviesResponse.self, from: response.data!){
                    print("success")
                    completion(jsonMovieResponse)
                    return
                }
                completion(nil)
                
            case .failure(_):
                print("Error with *favourite movies*")
                completion(nil)
                
            }
        }
    }
    
    
    
    
    func getTrendingMovies(page: Int, language: String, _ completion: @escaping (TrendingMoviesResponse?) -> ()){
        
        let baseUrl = "https://api.themoviedb.org/3"
        let endpoint = "/trending/movie/week"
        AF.request(baseUrl + endpoint, parameters: ["api_key": apiKey, "page": page, "language": language]).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                // print("TrendingMovies = \(value)")
                let decoder = JSONDecoder()
                
                if let jsonMovieResponse = try? decoder.decode(TrendingMoviesResponse.self, from: response.data!){
                    print("success")
                    completion(jsonMovieResponse)
                    return
                    
                }
                completion(nil)
                
                
                
                
            case .failure(_):
                print("Error with *trending movies*")
                completion(nil)
            }
            
        }
    }
    
    
    func getTopRatedMovies(page: Int, _ completion: @escaping (TopRatedMoviesResponse?) -> ()){
        let baseUrl = "https://api.themoviedb.org/3"
        let endpoint = "/movie/top_rated"
        completion(nil)
        
        AF.request(baseUrl + endpoint, parameters: ["api_key": apiKey, "page": page]).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                print("TopRatedMovies = \(value)")
                let decoder = JSONDecoder()
                
                if let jsonMovieResponse = try? decoder.decode(TopRatedMoviesResponse.self, from: response.data!){
                    print("success")
                    completion(jsonMovieResponse)
                    return
                    
                }
                completion(nil)
                
                
                
                
            case .failure(_):
                print("Error with *top rated movies*")
                completion(nil)
            }
            
        }
        
        
    }
    
    func getUpcomingMovies(page: Int, _ completion: @escaping (UpcomingMoviesResponse?) -> ()){
        let baseUrl = "https://api.themoviedb.org/3"
        let endpoint = "/movie/upcoming"
        completion(nil)
        
        AF.request(baseUrl + endpoint, parameters: ["api_key": apiKey, "page": page]).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                print("Upcoming Movies = \(value)")
                let decoder = JSONDecoder()
                
                if let data = response.data , let utf8Text = String(data: data, encoding: .utf8){
                    print("JSON.DATA = \(utf8Text)")
                }
                
                
                
                if let jsonMovieResponse = try? decoder.decode(UpcomingMoviesResponse.self, from: response.data!){
                    print("success")
                    completion(jsonMovieResponse)
                    return
                    
                }
                completion(nil)
                
                
                
                
            case .failure(_):
                print("Error with *upcoming movies*")
                completion(nil)
            }
            
        }
        
        
    }
    

    
    
    func addToWatchlist(movieId: String) {
        
        //        print("Session_id = \(sessionID!)")
        //        print("accountInfo?.id = \(accountInfo!.id)")
        //        print("apiKey = \(apiKey)")
        //        print("movieID = \(movieId)")
        
        // https://api.themoviedb.org/3/account/17215644/watchlist?api_key=15ec7b54d43e199ced41a6e461173cee&session_id=9779e7f6bfbab5dde0757cff983e7e2bf1dae04f&media_type=movie&media_id=11216&watchlist=true
        
        let accountId = accountInfo!.id
        print("SESSION_ID = \(sessionID!)")
        
        //        let url = "https://api.themoviedb.org/3/account/\(accountId)/watchlist?"
        
        let url = "https://api.themoviedb.org/3/account/17215644/watchlist?api_key=15ec7b54d43e199ced41a6e461173cee&session_id=\(sessionID!)"
        
        // 0d66f2f42c8a4c06e37ec9ebf67bcc5b143240e8
        // 9779e7f6bfbab5dde0757cff983e7e2bf1dae04f
        //
        let parameters: [String: Any] = [
            //"api_key": apiKey,
            //"session_id": sessionID!,
            "media_id": movieId,
            "watchlist": true,
            "media_type": "movie"
            
        ]
        
        //        let parameters: [String: Any] = [:]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        //        let parametersWithApiKey = parameters.merging(["api_key": apiKey]) { (_, new) in new }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print(url)
                    print(parameters)
                    print("Success: \(value)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    
    func getMoviesByGenre(page: Int, genre: String, _ completion: @escaping (GenresMoviesResponse?) -> ()){
        let url = "https://api.themoviedb.org/3/discover/movie"
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "sort_by": "popularity.desc",
            "with_genres": getGenreId(for: genre),
            "page": page
            //   "certification_country": "US",
            // "certification": "G"
            
        ]
        completion(nil)
        
        
        
        AF.request(url, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Genres movies = \(value)")
                let decoder = JSONDecoder()
                
                if let data = response.data , let utf8Text = String(data: data, encoding: .utf8){
                    print("JSON.DATA = \(utf8Text)")
                }
                
                if let jsonData = response.data,
                   let jsonMovieResponse = try? decoder.decode(GenresMoviesResponse.self, from: jsonData) {
                    print("success")
                    completion(jsonMovieResponse)
                } else {
                    print("Failed to decode JSON")
                    completion(nil)
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(nil)
            }
        }
    }
    
    
    
    
    
    
    func getGenreId(for genre: String) -> Int {
        
        let genreIds: [String: Int] = [
            "Action": 28,
            "Adventure": 12,
            "Animation": 16,
            "Comedy": 35,
            "Crime": 80,
            "Documentary": 99,
            "Drama": 18,
            "Family": 10751,
            "Fantasy": 14,
            "History": 36,
            "Horror": 27,
            "Music": 10402,
            "Mystery": 9638,
            "Romance": 10749,
            "Science Fiction": 878,
            "TV Movie": 10770,
            "Thriller": 53,
            "War": 10752,
            "Western": 37
        ]
        
        return genreIds[genre] ?? 0
    }
    
    
    func fetchMovieTrailer(movieID: Int, completion: @escaping (String?) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiKey)"
        
        AF.request(url).responseDecodable(of: MovieVideoResponse.self) { response in
            switch response.result {
            case .success(let videoResponse):
                print("Video response: \(videoResponse)") // Выводим информацию о полученных данных
                if let trailer = videoResponse.results.first(where: { $0.type == "Trailer" }) {
                    let trailerURLString = "https://www.youtube.com/watch?v=\(trailer.key)"
                    completion(trailerURLString)
                } else {
                    completion(nil) // Если трейлер не найден
                }
            case .failure(let error):
                print("Error fetching movie trailer: \(error)")
                completion(nil)
            }
        }
    }
    
    
    func rateMovie(movieID: Int, ratingValue: Double, sessionID: String, completion: @escaping (Bool) -> ()) {
        let baseUrl = "https://api.themoviedb.org/3"
        let endpoint = "/movie/\(movieID)/rating"
        
        var components = URLComponents(string: baseUrl + endpoint)
        components?.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "session_id", value: sessionID),
            URLQueryItem(name: "value", value: String(ratingValue))
        ]
        
        if let url = components?.url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            AF.request(request).response { response in
                switch response.result {
                case .success(_):
                    if let statusCode = response.response?.statusCode, statusCode == 201 {
                        completion(true)
                    } else {
                        completion(false)
                    }
                    
                case .failure(_):
                    completion(false)
                }
            }
            
            print(request)
        }
    }
    
    
    func markAsFavourite(movieId: String, value: Bool) {
        let accountId = accountInfo!.id
        let url = "https://api.themoviedb.org/3/account//(accountId)/favorite?api_key=15ec7b54d43e199ced41a6e461173cee&session_id=\(sessionID!)"
        
        let parameters: [String: Any] = [
            "media_type": "movie",
            "media_id": movieId,
            "favorite": value
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Success: \(value)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
    }
    
    
    
    func getMovieCast(movieId: String, completion: @escaping (Result<CastResponse, Error>) -> Void) {
           let url = "https://api.themoviedb.org/3/movie/\(movieId)/credits"
           let apiKey = apiKey

           let parameters: [String: Any] = [
               "api_key": apiKey
           ]

           AF.request(url, method: .get, parameters: parameters)
               .validate()
               .responseDecodable(of: CastResponse.self) { response in
                   switch response.result {
                   case .success(let castResponse):
                       completion(.success(castResponse))
                   case .failure(let error):
                       completion(.failure(error))
                   }
               }
       }
    
    
    func compressImageBaseUrl(imagePath: String, width: Int) -> String {
        let baseUrl = "https://image.tmdb.org/t/p/w\(width)"
        return "\(baseUrl)\(imagePath)"
    }
    
    
    func getDetailAccountInfo(){
        

        let userID = accountInfo?.id

        let userDetailsURL = "https://api.themoviedb.org/3/account?api_key=\(apiKey)&session_id=\(String(describing: sessionID))"

        AF.request(userDetailsURL).responseJSON { response in
            switch response.result {
            case .success(let value):

                print("Дополнительная информация о пользователе: \(value)")
                
            case .failure(let error):
                print("Ошибка: \(error)")
            }
        }
    }
    
    
}
