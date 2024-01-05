//
//  SelectedRegion.swift
//  TMDB App
//
//  Created by KIm on 17.09.2023.
//

import Foundation

struct SelectedRegion{
    
    
    static var shared = SelectedRegion()
    
    var region: String = "en-US"
    
    private init(){}
}

