//
//  NetworkManager.swift
//  TMDB App
//
//  Created by Kim on 27.04.2023 😎🙌
//

import Foundation
import Alamofire

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
    
    func getFavoriteMovies(_ completion: @escaping (MovieResponse?) -> ()){
        
        let parameters: [String: String] = ["account_id": String(accountInfo!.id)]
        
        let httpString = "https://api.themoviedb.org/3/account/" + String(accountInfo!.id) + "/favorite/movies?api_key="
        let bodyString = apiKey + "&session_id=" + sessionID! + "&language=en-US&sort_by=created_at.asc&page=1"
        let urlString = httpString + bodyString
        
        AF.request(urlString, method: .get, parameters: parameters).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                
                print("VALUE = \(value)")
                
                let decoder = JSONDecoder()
                
                if let jsonMovieResponse = try? decoder.decode(MovieResponse.self, from: response.data!){
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
    
    
    
    
    func getTrendingMovies(page: Int, _ completion: @escaping (TrendingMoviesResponse?) -> ()){
        
        let baseUrl = "https://api.themoviedb.org/3"
        let endpoint = "/trending/movie/week"
            AF.request(baseUrl + endpoint, parameters: ["api_key": apiKey, "page": page]).responseJSON { response in
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
    
    
    func getDailyTrendingMovies(_ completion: @escaping (DailyTrendingMoviesResponse?) -> ()){
        let baseUrl = "https://api.themoviedb.org/3"
        let endpoint = "/movie/upcoming"
        completion(nil)
        
        AF.request(baseUrl + endpoint, parameters: ["api_key": apiKey, "page": 1]).responseJSON { response in
            switch response.result {
            case .success(let value):
                
                print("Upcoming Movies = \(value)")
                let decoder = JSONDecoder()
                
                if let jsonMovieResponse = try? decoder.decode(DailyTrendingMoviesResponse.self, from: response.data!){
                    print("success")
                    completion(jsonMovieResponse)
                    return
                    
                }
                completion(nil)
                
                
                
                
            case .failure(_):
                print("Error with *daily movies*")
                completion(nil)
            }
            
        }
    }
    
    func addToWatchlist(movieId: Int){
        print("Session_id = \(sessionID!)")
        print("accountInfo?.id = \(accountInfo!.id)")
        print("apiKey = \(apiKey)")
        print("movieID = \(movieId)")
    }
        
        /* func markAsFavourite(movieId: Int){
            print("Session_id = \(sessionID!)")
            print("accountInfo?.id = \(accountInfo!.id)")
            print("apiKey = \(apiKey)")
            
           
            let url = "https://api.themoviedb.org/3/account/\(accountInfo!.id)/favorite"
            let parameters: Parameters = [
                    "media_type": "movie",
                    "media_id": movieId,
                    "favorite": true
                ]
            let headers: HTTPHeaders = [
                "Authorization": "\(String(describing: sessionID))",
                "api_key": apiKey
                ]
            AF.request(url, method: .post, parameters: parameters, headers: headers)
                   .validate()
                   .responseJSON { response in
                       switch response.result {
                       case .success:
                           print("Movie marked as favorite successfully!")
                       case .failure(let error):
                           print("Failed to mark movie as favorite: \(error)")
                       }
                   }
        
        
        
    }
    */
    
//    func getDailyTrendingMovies(completion: @escaping ([DailyTrendingMoviesResponse]?) -> Void){
//        let baseUrl = "https://api.themoviedb.org/3"
//           let endpoint = "/trending/movie/day"
//
//           let dateFormatter = DateFormatter()
//           dateFormatter.dateFormat = "yyyy-MM-dd"
//           let currentDate = dateFormatter.string(from: Date())
//
//           AF.request(baseUrl + endpoint, parameters: ["api_key": apiKey, "date": currentDate, "page": 1]).responseJSON { response in
//               switch response.result {
//               case .success(let value):
//
//                   let decoder = JSONDecoder()
//
//
////                   if let data = response.data, let movieResponse = try? decoder.decode(DailyTrendingMoviesResponse.self, from: data) {
////                       let movies = movieResponse.results
////                       completion(movies)
////
////                   } else {
////                       completion(nil)
////                   }
//                   if let jsonMovieResponse = try? decoder.decode(DailyTrendingMoviesResponse.self, from: response.data!){
//                       print("success")
//                       completion(jsonMovieResponse)
//                       return
//
//                   }
//                   completion(nil)
//
//               case .failure(let error):
//                   print("Error: \(error)")
//                   completion(nil)
//               }
//           }
//    }
    
    
    func getMoviesByGenre(genre: String, _ completion: @escaping (GenresMoviesResponse?) -> ()){
        let url = "https://api.themoviedb.org/3/discover/movie"
        let parameters: [String: Any] = [
            "api_key": apiKey,
            "sort_by": "popularity.desc",
            "with_genres": getGenreId(for: genre),

            "page": 1
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
                       "Comedy": 35,
                       "Family": 10751,
                       "Fantasy": 14,
                       "Science Fiction": 878,
                       "Thriller": 53
                   ]
            
            return genreIds[genre] ?? 0
        }
    
    
    
}



