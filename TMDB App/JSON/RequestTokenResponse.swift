//
//  JSON.swift
//  TMDB App
//
//  Created by KIm on 27.04.2023.
//

import Foundation


struct RequestTokenResponse: Decodable {
    var success: String?
    var requestToken: String?
    var expiresAt: String?
    
    enum CodingKeys: String, CodingKey {
        case requestToken = "request_token", expiresAt = "expires_at"
    }

}
