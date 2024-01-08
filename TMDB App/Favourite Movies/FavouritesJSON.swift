//
//  MoviesInfo.swift
//  TMDB App
//
//  Created by KIm on 13.05.2023.
//

import Foundation

struct FavouritesMoviesResponse: Codable {
    let page: Int
    let results: [FavouriteMovie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct FavouriteMovie: Codable {
        let adult: Bool
        let backdropPath: String
        let genreIDS: [Int]?
        let id: Int
        let originalLanguage: String
        let originalTitle, overview: String
        let popularity: Double
        let posterPath, releaseDate, title: String
        let video: Bool
        let voteAverage: Double
        let voteCount: Int

    enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case genreIDS = "genre_ids"
            case id
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview, popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title, video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
    var unwrappedBackdropPath: String {
            return backdropPath ?? ""
        }
}


extension FavouriteMovie: DetailGenresMovieProtocol {
    var posterURL: URL? {
        return URL(string: "https://www.themoviedb.org/t/p/w780\(posterPath)")
    }
    
    var type: MovieType {
        return .genresSorted
    }
    
    var voteAverageDouble: Double? {
        return voteAverage
    }
    
    var voteCountInt: Int? {
        return voteCount
    }
    
    var imageURL: URL? {
        return URL(string: "https://www.themoviedb.org/t/p/w780\(backdropPath)")
    }
    
    var releaseDateString: String? {
        return releaseDate
    }
    
    var genresIDS: [Int]? {
        guard let id = genreIDS else { return nil}
        return id
    }
    
    var moviesIDS: Int {
        return id
    }
    
    
}
