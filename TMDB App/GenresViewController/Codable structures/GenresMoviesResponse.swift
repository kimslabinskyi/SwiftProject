//
//  GenreStruct.swift
//  TMDB App
//
//  Created by KIm on 01.08.2023.
//

import Foundation


struct GenresMoviesResponse: Codable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [GenreMovie]
    
    private enum CodingKeys: String, CodingKey {
        case page, totalPages = "total_pages", totalResults = "total_results", results
    }
}

struct GenreMovie: Codable {
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

struct OptionalString: Codable {
    let value: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(String?.self)
    }
}

extension GenreMovie: DetailGenresMovieProtocol{
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
