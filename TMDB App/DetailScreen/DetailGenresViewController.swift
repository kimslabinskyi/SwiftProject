//
//  DetailTrendingMovieViewController.swift
//  TMDB App
//
//  Created by KIm on 01.06.2023.
//

import UIKit
import Alamofire
import SafariServices

enum MovieType {
    case top
    case trending
    case upcoming
    case genresSorted
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
    var posterURL: URL? { get }
}

class DetailGenresViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdrop: UIImageView!
    
    @IBOutlet weak var descriptionOfMovie: UITextView!
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    
    @IBOutlet weak var voteCountLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
        
    
    
    
    @IBAction func playButton(_ sender: Any) {
        
        print(detailedMovie?.moviesIDS ?? 2)
        NetworkManager.shared.fetchMovieTrailer(movieID: detailedMovie?.moviesIDS ?? 2) { trailerURLString in
            
            if trailerURLString != nil{
               
                if let url = URL(string: trailerURLString!) {
                    let safariViewController = SFSafariViewController(url: url)
                    self.present(safariViewController, animated: true, completion: nil)
                }
            } else {
        
            }
        }
    }
    
    
    
    @IBAction func addRatingButton(_ sender: Any){
        

        
//       NetworkManager.shared.rateMovie(movieID: detailedMovie?.moviesIDS ?? 0, ratingValue: 10.0, sessionID: "9779e7f6bfbab5dde0757cff983e7e2bf1dae04f"){ success in
//
//            print("id = \(self.detailedMovie?.moviesIDS ?? 0)")
//
//            if success {
//                    print("Рейтинг успешно установлен!")
//                } else {
//                    print("Произошла ошибка при установке рейтинга.")
//                }
//
//        }
        
    }

    
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
        
        
        if let url = detailedMovie?.imageURL {
            
            loadImageUsingAlamofire(from: url) { image in
                self.backdrop.image = image
            }
        } else {
            backdrop.image = UIImage(named: "AppIcon")
        }
        
        //Data to pass
        if let dataToPass = detailedMovie?.posterURL {
            self.posterURLToPass = dataToPass
        }
        if let dataToPass = detailedMovie?.moviesIDS{
            self.movieIDToPass = dataToPass
        }
        if let voteAverage = detailedMovie?.voteAverageDouble {
            let dataToPass = String(format: "%.1f", voteAverage)
            self.voteAverageToPass = dataToPass
        } else {
            print("No average rating")
        }

        if let dataToPass = detailedMovie?.title{
            self.labelToPass = dataToPass
        }
    }
    
    var posterURLToPass: URL?
    var movieIDToPass: Int?
    var voteAverageToPass: String?
    var labelToPass: String? 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RateViewController {
            destinationViewController.receivedPosterURL = posterURLToPass
            destinationViewController.receivedMovieID = movieIDToPass
            destinationViewController.receivedVoteAverage = voteAverageToPass
            destinationViewController.receivedLabel = labelToPass
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
