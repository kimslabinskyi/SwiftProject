//
//  DailyTrendingMovies.swift
//  TMDB App
//
//  Created by KIm on 16.06.2023.
//

import Foundation

struct DailyTrendingMoviesResponse: Codable {
        let page: Int
        let totalPages: Int
        let totalResults: Int
        let results: [DailyTrendingMovie]
        
        private enum CodingKeys: String, CodingKey {
            case page, totalPages = "total_pages", totalResults = "total_results", results
        }
    }

    struct DailyTrendingMovie: Codable {
        let id: Int
        let adult: Bool
        let backdropPath: String
        let originalTitle: String
        let mediaType: String
        let genreIDS: [Int]
        let originalLanguage: String
        let overview: String
        let popularity: Double
        let posterPath: String
        let voteAverage: Double?
        let voteCount: Int
        let title: String
        let video: Bool
        let releaseDate: String

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

