//
//  WatchlistData.swift
//  TMDB App
//
//  Created by Kim on 01.05.2024.
//

import Foundation

class WatchlistData{
    
    static let shared = WatchlistData()
    var watchlistMoviesDataSource: [WatchlistMovie] = []
    var watchlistData: [Int] = []
    
    func getData(){
        watchlistData = []
    
        NetworkManager.shared.getWatchlistMovies { [weak self] movieResponse in
            guard let self = self else { return }
            
            if let movieResponse = movieResponse {
                self.watchlistMoviesDataSource = movieResponse.results
                for i in watchlistMoviesDataSource{
                    watchlistData.append(i.id)
                }         
            }
        }
        
    }
    
    
    
}
