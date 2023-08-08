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
}

extension GenreMovie: DetailGenresMovieProtocol{
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

//enum OriginalLanguage: String, Codable {
//    case en = "en"
//    case fr = "fr"
//    case ja = "ja"
//}


//extension GenreMovie: DetailGenresMovieProtocol {
//    var moviesIDS: Int {
//        return id
//    }
//
//    var genresIDS: [Int]? {
//        guard let id = genreIDS else { return nil}
//        return id
//    }
//
//
//    var releaseDateString: String? {
//        guard let realiseDate = releaseDate else { return nil }
//        return realiseDate
//    }
//
//    var voteCountInt: Int? {
//        guard let voteCount = voteCount else { return nil }
//        return voteCount
//    }
//
//
//    var type: MovieType {
//        .trending
//    }
//
//    var voteAverageDouble: Double? {
//        guard let voteAverage = voteAverage else { return nil }
//        return voteAverage
//    }
//
//    var imageURL: URL? {
//         URL(string: "https://www.themoviedb.org/t/p/w780\(backdropPath)")
//    }
//
//}
//
