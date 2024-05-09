//
//  RatedMoviesData.swift
//  TMDB App
//
//  Created by Kim on 03.05.2024.
//

import Foundation


class RatedMoviesData{

    static let shared = RatedMoviesData()
    var dataSourceRatedMovies: [RatedMovie] = []
    var listOfRatedMovies: [Int] = []
    
    func getData(page: Int){
        listOfRatedMovies = []
    
        NetworkManager.shared.getRatedMovies(page: page) { [weak self] movieResponse in
            guard let self = self else { return }
            
            if let movieResponse = movieResponse {
                print("movieResponse = \(movieResponse)")
                self.dataSourceRatedMovies = movieResponse.results
                for i in dataSourceRatedMovies{
                    listOfRatedMovies.append(i.id)
                }
            }
        }
    }
    
    
}
