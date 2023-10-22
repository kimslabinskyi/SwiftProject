//
//  File.swift
//  TMDB App
//
//  Created by KIm on 30.04.2023.
//

import Foundation

struct Response: Codable {
    let success: Bool;
    let failure: Bool;
    let status_code: Int;
    let status_message: String
}


