//
//  AccountInfo.swift
//  TMDB App
//
//  Created by KIm on 05.05.2023.
//

import Foundation

struct AccountInfo {
    let username: String
    let iso_3166_1: String
    let iso_639_1: String
    let id: Int
    
    init?(dictionary: [String: Any]) {
        guard let username = dictionary["username"] as? String,
              let iso_3166_1 = dictionary["iso_3166_1"] as? String,
              let iso_639_1 = dictionary["iso_639_1"]
                  as? String,
              let id = dictionary["id"] as? Int
        else { return nil }
        
        self.id = id
        self.iso_639_1 = iso_639_1
        self.iso_3166_1 = iso_3166_1
        self.username = username
    }
}
