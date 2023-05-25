//
//  DetailFavouritesMovies.swift
//  TMDB App
//
//  Created by KIm on 10.05.2023.
//

import UIKit

class DetailFavouritesMovies: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    var detailedMovie: Movie?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = detailedMovie?.title        
    }
}

