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
    case found
    case watchlist
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
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var descriptionOfMovie: UITextView!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var addToWatchlistButton: UIButton!
    @IBOutlet weak var favouritesButton: UIButton!
    
    var castNames = [String]()
    var characterNames = [String]()
    var mainDetailMovie: String?
    var genresInfo = [String]()
    var castImages = [String]()
    var receivedFavouriteValue: Bool = false
    var receivedWatchlistValue: Bool = false 

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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        getMovieCast()
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
        descriptionOfMovie.showsVerticalScrollIndicator = false
        descriptionOfMovie.isEditable = false
        descriptionOfMovie.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        
        favouritesButton.titleLabel?.textColor = .white
        favouritesButton.layer.cornerRadius = 7
        
        addToWatchlistButton.layer.cornerRadius = 7
        
        rateButton.titleLabel?.textColor = .white

        print("detailedMovie = \(String(describing: detailedMovie))")
        
        for genreId in movieIDS! {
            if let genreName = genres[genreId] {
                genresInfo.append(genreName)
            }
        }
        
        if let url = detailedMovie?.imageURL {
            NetworkManager.shared.loadImageUsingAlamofire(from: url) { image in
                self.backdrop.image = image
            }
        }
        
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
            
        
        if receivedFavouriteValue == true {
            print("FAVOURITE = 1")
            favouritesButton.setTitle("Liked", for: .normal)
            favouritesButton.setTitleColor(.white, for: .normal)
            favouritesButton.backgroundColor = .gray
            
        } else {
            print("FAVOURITE = 0")
            favouritesButton.setTitleColor(.white, for: .normal)
            favouritesButton.backgroundColor = .systemMint

        }
        
        if receivedWatchlistValue == true {
            addToWatchlistButton.setTitle("Added to watchlist", for: .normal)
            addToWatchlistButton.setTitleColor(.white, for: .normal)
            addToWatchlistButton.backgroundColor = .gray
        } else {
            addToWatchlistButton.setTitleColor(.white, for: .normal)
            addToWatchlistButton.backgroundColor = .systemMint
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    

    
    func getMovieCast() {
            NetworkManager.shared.getMovieCast(movieId: String(detailedMovie?.moviesIDS ?? 2)) { result in
                switch result {
                case .success(let castResponse):
                    print("Count of casts = \(castResponse.cast.count)")

                    let numberOfElementsToAdd = min(6 - self.castNames.count, castResponse.cast.count)
                    
                    for i in 0..<numberOfElementsToAdd {
                        let actor = castResponse.cast[i]
                        self.castImages.append(actor.profilePath ?? "Empty")
                        self.castNames.append(actor.name ?? "Empty")
                        self.characterNames.append(actor.character ?? "Empty")
                    }
                    
                    if self.castNames.count == 6 {
                        self.collectionView.reloadData()
                    }
                    
                case .failure(let error):
                    print("Error fetching movie cast: \(error)")
                }
            }
            
            
            
        }
    
   
    
    var posterURLToPass: URL?
    var movieIDToPass: Int?
    var voteAverageToPass: String?
    var labelToPass: String? 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? RateScreenViewController {
            destinationViewController.receivedPosterURL = posterURLToPass
            destinationViewController.receivedMovieID = movieIDToPass
            destinationViewController.receivedVoteAverage = voteAverageToPass
            destinationViewController.receivedLabel = labelToPass
        }
    }
    
    
    

    
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

    }

    
    @IBAction func addToWatchlistButton(_ sender: Any) {
   
        if receivedWatchlistValue == false{
             //NetworkManager.shared.addToWatchlist(movieId: String(detailedMovie?.moviesIDS ?? 2), value: true)
            WatchlistData.shared.changeData(id: String(detailedMovie?.moviesIDS ?? 0), value: true)
            receivedWatchlistValue = true
            addToWatchlistButton.setTitle("Added to watchlist", for: .normal)
            addToWatchlistButton.setTitleColor(.white, for: .normal)
            addToWatchlistButton.backgroundColor = .gray
        } else {
            WatchlistData.shared.changeData(id: String(detailedMovie?.moviesIDS ?? 0), value: false)
            receivedWatchlistValue = false
            addToWatchlistButton.setTitle("Add to watchlist", for: .normal)
            addToWatchlistButton.setTitleColor(.white, for: .normal)
            addToWatchlistButton.backgroundColor = .systemMint
        }
        
        
        
        
        // NetworkManager.shared.addToWatchlist(movieId: String(detailedMovie?.moviesIDS ?? 2), value: true)
    }
    

    @IBAction func addToFavouritesButton(_ sender: Any) {
        if receivedFavouriteValue == false {
        NetworkManager.shared.markAsFavourite(movieId: String(detailedMovie?.moviesIDS ?? 0), value: true)
            receivedFavouriteValue = true
            favouritesButton.setTitle("Liked", for: .normal)
            favouritesButton.setTitleColor(.white, for: .normal)
            favouritesButton.backgroundColor = .gray
        } else {
            NetworkManager.shared.markAsFavourite(movieId: String(detailedMovie?.moviesIDS ?? 0), value: false)
            receivedFavouriteValue = false
            favouritesButton.setTitle("Like", for: .normal)
            favouritesButton.setTitleColor(.white, for: .normal)
            favouritesButton.backgroundColor = .systemMint
        }
        
    }
    
    
   

}

extension DetailGenresViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        genresInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenresCell", for: indexPath) as! DetailGenresTableViewCell
//         cell.genreNameLabel.text = genresInfo[indexPath.row]
        cell.genresNameLabel.text = genresInfo[indexPath.row]
        return cell
    }
    
    
    
    
}


extension DetailGenresViewController: UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath) as! CastCollectionViewCell
        cell.imageView.image = UIImage(named: "question_mark")
        
        if indexPath.item < castNames.count{
            cell.nameOfActorLabel.text = castNames[indexPath.item]
        }
        
        if indexPath.item < characterNames.count {
            cell.secondLabel.text = characterNames[indexPath.item]
        }
        
        
        if indexPath.item < castImages.count{
            let imageUrl = castImages[indexPath.item]

            if imageUrl != "Empty" {
            
                ImageManager.getImageForPosterName("https://image.tmdb.org/t/p/w200" + imageUrl) { image in
                    cell.imageView.image = image ?? UIImage(named: "question_mark")}
            } else {

                cell.imageView.image = UIImage(named: "question_mark")
            }
        }
        
        
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 125
        let height = 211
        return CGSize(width: width, height: height)
    }
    
}
