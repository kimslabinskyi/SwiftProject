//
//  RatedMoviesJSON.swift
//  TMDB App
//
//  Created by Kim on 03.05.2024.
//

import Foundation



struct RatedMoviesResponse: Codable {
    let totalResults: Int
    let totalPages: Int
    let results: [RatedMovie]
    let page: Int
    
    private enum CodingKeys: String, CodingKey {
        case totalResults = "total_results", totalPages = "total_pages", results, page
    }
    
}


struct RatedMovie: Codable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String?
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int?

    
    
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
}

extension RatedMovie: DetailGenresMovieProtocol{
       
    var posterURL: URL? {
        URL(string: "https://www.themoviedb.org/t/p/w780\(posterPath ?? "")")
    }
    
    var type: MovieType {
        return .found
    }
    
    var voteAverageDouble: Double? {
        return voteAverage
    }
    
    var voteCountInt: Int? {
        return voteCount
    }
    
    var imageURL: URL? {
        URL(string: "https://www.themoviedb.org/t/p/w780\(backdropPath ?? "")")
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
