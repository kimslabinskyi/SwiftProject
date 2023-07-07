//
//  DetailTrendingMovieViewController.swift
//  TMDB App
//
//  Created by KIm on 01.06.2023.
//

import UIKit
import Alamofire

protocol DetailGenresMovie {
    var showTitle: String { get }
    var showOverview: String { get }
}

class DetailGenresViewController: UIViewController {
    
    var delegate: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdrop: UIImageView!
    
    @IBOutlet weak var descriptionOfMovie: UITextView!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    @IBOutlet weak var voteCountLabel: UILabel!
    //var genres: GenresViewController!
    var mainDetailMovie: String?
  
        //MARK: Detailed Movies
    var detailedTrendingMovie: TrendingMovie?
    var detailedTopRatedMovie: TopRatedMovie?
    var detailedUpcomingMove: UpcomingMovie?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("delegate = \(delegate)")
        if delegate == "Trending"{
            setTrendingMovie()
        } else if delegate == "TopRated"{
            setTopRatedMovie()
        } else if delegate == "Upcoming"{

        } else {
            print("Not correct information")

        }
        
        
        
    }
    
    func setTrendingMovie(){
            titleLabel.text = detailedTrendingMovie?.title
        descriptionOfMovie.text = detailedTrendingMovie?.overview
            let voteAverageString = String(format: "%.1f", detailedTrendingMovie?.voteAverage ?? "")
            
            if let voteAverage = detailedTrendingMovie?.voteAverage {
                voteAverageLabel.text = String(voteAverage)
            } else {
                print("Error: cannot find vote average")
            }
            
            
            if let voteCount = detailedTrendingMovie?.voteCount {
                voteCountLabel.text = String(voteCount)
            } else {
                print("Error: cannot find vote count")
            }
            
            
            let backdropName = detailedTrendingMovie?.backdropPath ?? ""
            if let url = URL(string: "https://www.themoviedb.org/t/p/w780\(backdropName)") {
                loadImageUsingAlamofire(from: url) { image in
                    self.backdrop.image = image
                }
            } else {
                backdrop.image = UIImage(named: "AppIcon")
            }
        
    }
    
    
    func setTopRatedMovie(){
            titleLabel.text = detailedTopRatedMovie?.title
        descriptionOfMovie.text = detailedTopRatedMovie?.overview
            let voteAverageString = String(format: "%.1f", detailedTopRatedMovie?.voteAverage ?? "")
            
            if let voteAverage = detailedTopRatedMovie?.voteAverage {
                voteAverageLabel.text = String(voteAverage)
            } else {
                print("Error: cannot find vote average")
            }
            
            
            if let voteCount = detailedTrendingMovie?.voteCount {
                voteCountLabel.text = String(voteCount)
            } else {
                print("Error: cannot find vote count")
            }
            
            
            let backdropName = detailedTrendingMovie?.backdropPath ?? ""
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

