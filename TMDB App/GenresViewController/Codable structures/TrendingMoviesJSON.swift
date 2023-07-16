//
//  PopularMoviesJSON.swift
//  TMDB App
//
//  Created by KIm on 31.05.2023.
//

import UIKit

struct TrendingMoviesResponse: Codable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [TrendingMovie]
    
    private enum CodingKeys: String, CodingKey {
        case page, totalPages = "total_pages", totalResults = "total_results", results
    }
}

struct TrendingMovie: Codable {
    let id: Int
    let adult: Bool
    let backdropPath: String
    let originalTitle: String
    let mediaType: String
    let genreIDS: [Int]?
    let originalLanguage: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let voteAverage: Double?
    let voteCount: Int?
    let title: String
    let video: Bool
    let releaseDate: String?

    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        , originalTitle = "original_title"
        , mediaType = "media_type"
        , genreIDS = "genre_ids"
        , voteAverage = "vote_average"
        , posterPath = "poster_path"
        , originalLanguage = "original_language"
        , voteCount = "vote_count"
        , releaseDate = "release_date"
        , video, id, adult, popularity, title, overview
    }
}

extension TrendingMovie: DetailGenresMovieProtocol {
    var moviesIDS: Int {
        return id
    }
    
    var genresIDS: [Int]? {
        guard let id = genreIDS else { return nil}
        return id
    }
    
    
    var releaseDateString: String? {
        guard let realiseDate = releaseDate else { return nil }
        return realiseDate
    }
    
    var voteCountInt: Int? {
        guard let voteCount = voteCount else { return nil }
        return voteCount
    }

    
    var type: MovieType {
        .trending
    }
    
    var voteAverageDouble: Double? {
        guard let voteAverage = voteAverage else { return nil }
        return voteAverage
    }
    
    var imageURL: URL? {       
         URL(string: "https://www.themoviedb.org/t/p/w780\(backdropPath)")
    }
    
}

