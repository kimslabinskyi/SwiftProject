//
//  UpcomingMovies.swift
//  TMDB App
//
//  Created by KIm on 09.06.2023.
//

import Foundation


struct UpcomingMoviesResponse: Codable {
    struct Dates: Codable {
        let maximum: String
        let minimum: String
    }
    
    let dates: Dates
    let page: Int
    let results: [UpcomingMovie]
}

struct UpcomingMovie: Codable {
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
    let voteAverage: Double?
    let voteCount: Int?
    
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
    
    var unwrappedBackdropPath: String {
            return backdropPath ?? ""
        }
    
}

extension UpcomingMovie: DetailGenresMovieProtocol {
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
        .upcoming
    }
    
    var voteAverageDouble: Double? {
//        guard let id = backdropPath else { return nil }
        #warning("Fix as below")
        return voteAverage
    }
    
    var imageURL: URL? {
        if backdropPath == nil {
            return nil
        } else {
            return URL(string: "https://www.themoviedb.org/t/p/w780\(backdropPath!)")
        }
    }
    
}

