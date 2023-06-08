//
//  DetailTrendingMovieViewController.swift
//  TMDB App
//
//  Created by KIm on 01.06.2023.
//

import UIKit
import Alamofire

class DetailTrendingMovieViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdrop: UIImageView!
    
    @IBOutlet weak var descrtiption: UITextView!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    @IBOutlet weak var voteCountLabel: UILabel!
    var detailedMovie: TrendingMovie?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = detailedMovie?.title
        descrtiption.text = detailedMovie?.overview
        let voteAverageString = String(format: "%.1f", detailedMovie?.voteAverage ?? "")
        
        if let voteAverage = detailedMovie?.voteAverage {
            voteAverageLabel.text = String(voteAverage)
        } else {
print("Error: cannot find vote average")
        }
        
        
        if let voteCount = detailedMovie?.voteCount {
            voteCountLabel.text = String(voteCount)
        } else {
print("Error: cannot find vote count")
        }
        
//        voteAverageLabel.text = voteAverageString
//        voteCount.text = String(detailedMovie?.voteCount)
        
        let backdropName = detailedMovie?.backdropPath ?? ""
        
        
//    "https://www.themoviedb.org/t/p/w780/tOfAkOf7TrAPuz4kKG5Fvq1seCd.jpg"
        
        
        if let url = URL(string: "https://www.themoviedb.org/t/p/w780\(backdropName)") {
            loadImageUsingAlamofire(from: url) { image in
                self.backdrop.image = image
            }
        } else {
            backdrop.image = UIImage(named: "AppIcon")
        }
    }
    
    
    func loadImageUsingAlamofire(from url: URL, completion: @escaping (UIImage?) -> Void) {
        AF.request(url).responseData { response in
            if let data = response.data {
                let image = UIImage(data: data)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    
}

