//
//  AVPStruct.swift
//  TMDB App
//
//  Created by KIm on 27.08.2023.
//

import Foundation

struct MovieVideoResponse: Decodable {
    let results: [MovieVideo]
}

struct MovieVideo: Decodable {
    let key: String
    let type: String
}
