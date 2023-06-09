//
//  TopRatedMoviesJSON.swift
//  TMDB App
//
//  Created by KIm on 09.06.2023.
//

import UIKit


struct TopRatedMoviesResponse: Codable {
    let page: Int
    let results: [TopRatedMovie]
    
    private enum CodingKeys: String, CodingKey {
        case page, results
    }
}

struct TopRatedMovie: Codable {
    let adult: Bool
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double?
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        , originalTitle = "original_title"
        , genreIDS = "genre_ids"
        , voteAverage = "vote_average"
        , posterPath = "poster_path"
        , originalLanguage = "original_language"
        , voteCount = "vote_count"
        , releaseDate = "release_date"
        , video, id, adult, popularity, title, overview


    }
}
