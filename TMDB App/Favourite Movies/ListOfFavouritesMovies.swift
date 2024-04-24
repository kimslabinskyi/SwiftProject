//
//  ListOfFavouritesMovies.swift
//  TMDB App
//
//  Created by Kim on 03.04.2024.
//

import Foundation

class ListOfFavouritesMovies{
    
    static let shared = ListOfFavouritesMovies()
    var dataSourceFavouritesMovies: [FavouriteMovie] = []
    var listOfFavouritesMovies: [Int] = []
    
    func getList(){
        listOfFavouritesMovies = []
        NetworkManager.shared.getFavoriteMovies({ [weak self] movieResponse, arg  in
            guard let self = self else { return }
            
            if let movieResponse = movieResponse {
                self.dataSourceFavouritesMovies = movieResponse.results

                
                for item in dataSourceFavouritesMovies{
                    print(item.id)
                    
                    listOfFavouritesMovies.append(item.id)
                    
                }
                
            }
        })
        
    }
    func cleanList(){
        listOfFavouritesMovies = []
    }
    
    
}


