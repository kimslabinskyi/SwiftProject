//
//  DetailTrendingMovieViewController.swift
//  TMDB App
//
//  Created by KIm on 01.06.2023.
//

import UIKit
import Alamofire

enum MovieType {
    case top
    case trending
    case upcoming
}

protocol DetailGenresMovieProtocol {
    var type: MovieType { get }
    var title: String { get }
    var overview: String { get }
    var voteAverageDouble: Double? { get }
    var voteCountInt: Int? { get }
    var imageURL: URL? { get }
    var releaseDateString: String? { get }
    var genresIDS: [Int]? { get }
    var moviesIDS: Int { get }
}

class DetailGenresViewController: UIViewController {
    
    var delegate: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdrop: UIImageView!
    
    @IBOutlet weak var descriptionOfMovie: UITextView!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    @IBOutlet weak var voteCountLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
//    @IBAction func addToFavouritesButton(_ sender: Any) {
//        NetworkManager.shared.markAsFavourite(movieId: detailedMovie?.moviesIDS ?? 0 )
//            print(detailedMovie?.moviesIDS ?? 78)
//
//
//    }
    
    @IBAction func addToWatchlistButton(_ sender: Any) {
        NetworkManager.shared.addToWatchlist(movieId: detailedMovie?.moviesIDS ?? 2)
    }
    
    //var genres: GenresViewController!
    var mainDetailMovie: String?
    
    var detailedMovie: DetailGenresMovieProtocol?
   let genres =
    [28: "Action" ,
     12: "Adventure",
     16: "Animation",
     35: "Comedy",
     80: "Crime",
     99: "Documentary",
     18: "Drama",
     10751: "Family",
     14: "Fantasy",
     36: "History",
     27: "Horror",
     10402: "Music",
     9638: "Mystery",
     10749: "Romance",
     878: "Science Fiction",
     10770: "TV Movie",
     53: "Triller",
     10752: "War",
     37: "Western" ]
    var genresInfo = [String]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
                
    }
    
    func setUp() {
        let voteAverage: String = String(format: "%.1f", detailedMovie?.voteAverageDouble ?? 0.01)
        let voteCount: String = String(detailedMovie?.voteCountInt ?? 0)
        let movieIDS = detailedMovie?.genresIDS
        
        titleLabel.text = detailedMovie?.title
        descriptionOfMovie.text = detailedMovie?.overview
        voteAverageLabel.text = voteAverage
        voteCountLabel.text = voteCount
        releaseDateLabel.text = detailedMovie?.releaseDateString
        print("detailedMovie = \(detailedMovie)")
        
        for genreId in movieIDS! {
            if let genreName = genres[genreId] {
                genresInfo.append(genreName)
            }
        }
        
        //        if let voteCount = detailedTrendingMovie?.voteCount {
        //            voteCountLabel.text = String(voteCount)
        //        } else {
        //            print("Error: cannot find vote count")
        //        }
        
        
        
        if let url = detailedMovie?.imageURL {
            
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
    var arrayOfItems = ["Apple", "Banana", "Orange", "Cherry"]
}

extension DetailGenresViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        genresInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenresCell", for: indexPath)
        cell.textLabel?.text = genresInfo[indexPath.row]
        return cell
    }
    
    
    
    
}
