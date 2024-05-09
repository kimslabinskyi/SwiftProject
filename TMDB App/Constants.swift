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
    
    static let detailTopRatedMovieSegue = "DetailTopRatedMovieSegue"
    
    static let detailUpcomingMovieSegue = "DetailUpcomingMovieSegue"
    
    static let detailFoundMovieSegue = "DetailFoundMovieSegue"
    
    static let detailWatchlist = "DetailWatchlist"
    
    static let moreGenresSegue = "moreGenresSegue"
    
    static let changeRatingSegue = "changeRatingSegue"
    
}


struct Defaults {
    private init() {}
    
    static let savedRequestToken = "RequestTokenSaved"
    static let savedSessionId = "SessionIdSaved"
}

struct ids{
    
    let genres =
     [28: "Action" ,
      12: "Adventure",
      16: "Animation",
      35: "Comedy",
      80: "Crime",
      99: "Documentary",
      18: "Drama",
      10751: "Family",
      14: "Fantasy",
      36: "History",
      27: "Horror",
      10402: "Music",
      9638: "Mystery",
      10749: "Romance",
      878: "Science Fiction",
      10770: "TV Movie",
      53: "Triller",
      10752: "War",
      37: "Western" ]
}
