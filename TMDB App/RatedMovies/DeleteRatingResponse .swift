//
//  DeleteRatingResponse .swift
//  TMDB App
//
//  Created by Kim on 29.06.2024.
//
import Foundation

struct DeleteRatingResponse: Decodable {
    let statusCode: Int
    let statusMessage: String

    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
