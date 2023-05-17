//
//  NetworkManager.swift
//  TMDB App
//
//  Created by KIm on 27.04.2023.
//

import Foundation
import Alamofire



class NetworkManager {
    
    //Another test commit
    
    
    
    var sessionID: String? {
        willSet {
            print("Val: \(sessionID)")
        }
    }
    var requestToken: String?
    let apiKey = "15ec7b54d43e199ced41a6e461173cee"
    var accountInfo: AccountInfo?
    var favouriteMoviesDetailInformation: FavouriteMoviesInfo?
    
    private init() {
        
    }
    
    static let shared = NetworkManager()
    
    
    func getRequestToken(_ callback: @escaping (Bool) -> () ) {
        //
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
        
        
        print("REQEST TOKEN -> \(requestToken!)")
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
    
    
    
}

