//
//  FavouriteMoviesInfo.swift
//  TMDB App
//
//  Created by KIm on 09.05.2023.
//

import Foundation



struct FavouriteMoviesInfo{
    let adult: Int
    let backdrop_path: String
  //  let genre_ids: [String]
    let id: Int
    let original_language: String
    let original_title: String
    let popularity: Double
    let poster_path: String
    let release_date: String
    let title: String
    let video: Int
    let vote_average: Double
    let vote_count: Int
    
    init?(dictionary: [String: Any]) {
        guard let adult = dictionary["adult"] as? Int,
              let backdrop_path = dictionary["iso_3166_1"] as? String,
              // let genre_ids = dictionary["iso_639_1"]
           //       as? String,
              let id = dictionary["id"] as? Int,
              let original_language = dictionary["original_language"] as? String,
              let original_title = dictionary["original_title"] as? String,
                let popularity = dictionary["popularity"] as? Double,
                let poster_path = dictionary["poster_path"] as? String,
                let release_date = dictionary["release_date"] as? String,
                let title = dictionary["title"]
                as? String,
              let video = dictionary["video"] as? Int,
              let vote_average = dictionary["vote_average"] as? Double,
                let vote_count = dictionary["vote_count"] as? Int
                
        else { return nil }
        
        self.adult = adult
        self.backdrop_path = backdrop_path
      //  self.genre_ids = [genre_ids]
        self.id = id
        self.original_language = original_language
        self.original_title = original_title
        self.popularity = popularity
        self.poster_path = poster_path
        self.release_date = release_date
        self.title = title
        self.video = video
        self.vote_average = vote_average
        self.vote_count = vote_count

    }
}




