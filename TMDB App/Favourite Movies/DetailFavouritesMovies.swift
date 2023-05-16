//
//  DetailFavouritesMovies.swift
//  TMDB App
//
//  Created by KIm on 10.05.2023.
//

import UIKit

class DetailFavouritesMovies: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.getFavoriteMovies(){
            movieResponse in
            print(movieResponse?.results.first?.originalTitle as Any)
            print(movieResponse?.results.first?.overview as Any)
            print(movieResponse?.results[1].title as Any)
//            let image = UIImage(
            
            
        }
        
        
        
        
    }
}

