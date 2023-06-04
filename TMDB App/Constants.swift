//
//  Constants.swift
//  TMDB App
//
//  Created by Oleksandr Slabinskyi on 25.05.2023.
//

import Foundation

/*
 Add different constants to this file
 */

//Constants for segue names

struct SegueId {
    
    private init() {}
    
    static let  detailFavouriteMovieInfoSegue = "DetailFavouriteMovieInfoSegue"
    
    static let detailTrendingMovieSegue = "DetailTrendingMovieSegue"
}


struct Defaults {
    private init() {}
    
    static let savedRequestToken = "RequestTokenSaved"
    static let savedSessionId = "SessionIdSaved"
}
