//
//  DetailTrendingMovieViewController.swift
//  TMDB App
//
//  Created by KIm on 01.06.2023.
//

import UIKit
import Alamofire

class DetailTrendingMovieViewController: UIViewController, GenresViewControllerDelegate {
    
    func didSelectMovie(_ movie: String) {
        if movie == "trendingMovie"{
            print("Success - trendingMovie")
        } else {
            print("Error with trendingMovie")
        }
    }
    var someProperty: String? 
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdrop: UIImageView!
    
    @IBOutlet weak var descrtiption: UITextView!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    @IBOutlet weak var voteCountLabel: UILabel!
    weak var delegate: GenresViewControllerDelegate?
    var detailedMovie: TrendingMovie?
    var genres: GenresViewController!
    var mainDetailMovie: String?
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("delegate = \(someProperty)")
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
            
            
            let backdropName = detailedMovie?.backdropPath ?? ""
            
            
            
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

