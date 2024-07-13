//
//  CollentionsViewController.swift
//  TMDB App
//
//  Created by KIm on 27.04.2023.
//

import UIKit
import Alamofire


class GenresViewController: UIViewController {
    
    @IBOutlet weak var dualCollectionView: UICollectionView!
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var genresTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var topLabel: UILabel!
    
    let apiKey = "15ec7b54d43e199ced41a6e461173cee"
    var animationLabelText = "What’s new, "
    var mainDetailMovie: String?
    var selectedMovieType: String?
    var hasAnimatedLabel = false

    
    var dataSourceTrendingMovies: [TrendingMovie] = []
    var dataSourceTopRatedMovies: [TopRatedMovie] = []
    var dataSourceUpcomingMovies: [UpcomingMovie] = []
    var dataSourceGenresMovies: [GenreMovie] = []
    var dataSourceFavouritesMovies: [FavouriteMovie] = []
    
    
    
    var selectedTrendingMovie: TrendingMovie?
    var selectedTopRatedMovie: TopRatedMovie?
    var selectedUpcomingMovie: UpcomingMovie?
    var selectedGenreMovie: GenreMovie?
    
    let trendingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let dailyTrendingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var tempCollectionView: UICollectionView?
    var selectedGenre: String?
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setUp()
        updateTabBarColors()
        
        fetchTrendingMovies()
        fetchTopRatedMovies()
        fetchUpcomingMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ListOfFavouritesMovies.shared.getList()
        WatchlistData.shared.getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateTabBarColors()
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                    updateTabBarColors()
                }
    }
    
    //MARK: IBAction func's
    
    @IBAction func moreTrendingMoviesButton(_ sender: Any) {
        selectedMovieType = "trending"
        performSegue(withIdentifier: "moreTrending", sender: self)
    }
    @IBAction func moreTopRatedMoviesButton(_ sender: Any) {
        selectedMovieType = "topRated"
        performSegue(withIdentifier: "moreTopRated", sender: self)
    }
    @IBAction func moreUpcomingMoviesButton(_ sender: Any) {
        selectedMovieType = "upcoming"
        performSegue(withIdentifier: "moreUpcoming", sender: self)
    }
    
    
    func setUp(){
        trendingCollectionView.register(TrendingMoviesCollectionViewCell.self, forCellWithReuseIdentifier: "TrendingCell")
        
        dualCollectionView.showsHorizontalScrollIndicator = false
        topRatedCollectionView.showsHorizontalScrollIndicator = false
        upcomingCollectionView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        genresTableView.showsVerticalScrollIndicator = false

        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .scaleAspectFit
        imageView.isLoading = true
        imageView.image = (UIImage(named: "question_mark"))
        
        
        if let accountInfo = NetworkManager.shared.accountInfo {
            animationLabelText = animationLabelText + accountInfo.username + "?"
        }
        
        ListOfFavouritesMovies.shared.getList()
    

    }
    
    
    func updateTabBarColors(){
        
        if traitCollection.userInterfaceStyle == .dark {
                    self.tabBarController?.tabBar.tintColor = UIColor.systemMint
                    self.tabBarController?.tabBar.barTintColor = UIColor.black
                } else {
                    self.tabBarController?.tabBar.tintColor = UIColor.systemMint
                    self.tabBarController?.tabBar.barTintColor = UIColor.white
                }
        
    }
    
    
    //MARK: Fetch Movies
  
    private func fetchTrendingMovies() {
        NetworkManager.shared.getTrendingMovies(page: 1, language: SelectedRegion.shared.region) {
            
            [weak self] trendingMoviesResponse in
            guard let self = self else { return }
            
            if let movies = trendingMoviesResponse {
                self.dataSourceTrendingMovies = movies.results
                self.dualCollectionView.reloadData()
            } else {
                print("Failed to fetch trending movies")
            }
        }
    }
    
    
    
    private func fetchTopRatedMovies() {
        NetworkManager.shared.getTopRatedMovies(page: 1) {
            [weak self] TopRatedMoviesResponse in
            guard let self = self else { return }
            
            if let movies = TopRatedMoviesResponse {
                self.dataSourceTopRatedMovies = movies.results
                self.topRatedCollectionView.reloadData()
            } else {
                print("Failed to fetch top rated movies")
            }
        }
    }
    
    private func fetchUpcomingMovies() {
        NetworkManager.shared.getUpcomingMovies(page: 1) {
            [weak self] UpcomingMoviesResponse in
            guard let self = self else { return }
            
            if let movies = UpcomingMoviesResponse {
                self.dataSourceUpcomingMovies = movies.results
                self.upcomingCollectionView.reloadData()
            } else {
                print("Failed to fetch upcoming movies")
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailTrendingMovieSegue" {
            if let destinationVC = segue.destination as? DetailGenresViewController {
                destinationVC.detailedMovie = selectedTrendingMovie
                
                if ListOfFavouritesMovies.shared.listOfFavouritesMovies.contains(selectedTrendingMovie?.id ?? 0){
                    print("success")
                    destinationVC.receivedFavouriteValue = true
                }
                if WatchlistData.shared.watchlistData.contains(selectedTrendingMovie?.id ?? 0){
                    destinationVC.receivedWatchlistValue = true
                }
                
            }
                         
        } else if segue.identifier == "DetailTopRatedMovieSegue"{
            if let destinationVC = segue.destination as? DetailGenresViewController {
                
                destinationVC.detailedMovie = selectedTopRatedMovie
                
                if ListOfFavouritesMovies.shared.listOfFavouritesMovies.contains(selectedTopRatedMovie?.id ?? 0){
                    destinationVC.receivedFavouriteValue = true
                }
                if WatchlistData.shared.watchlistData.contains(selectedTopRatedMovie?.id ?? 0){
                    destinationVC.receivedWatchlistValue = true
                }
                
            }
            
        } else if segue.identifier == "DetailUpcomingMovieSegue" {
            if let destinationVC = segue.destination as? DetailGenresViewController {

                destinationVC.detailedMovie = selectedUpcomingMovie
                
                if ListOfFavouritesMovies.shared.listOfFavouritesMovies.contains(selectedUpcomingMovie?.id ?? 0){
                    destinationVC.receivedFavouriteValue = true
                }
                if WatchlistData.shared.watchlistData.contains(selectedUpcomingMovie?.id ?? 0){
                    destinationVC.receivedWatchlistValue = true
                }
            }
        } else if segue.identifier == "moreTrending" {
            if let moreViewController = segue.destination as? MoreViewController {
                moreViewController.movieType = selectedMovieType
            }
        } else if segue.identifier == "moreTopRated" {
            if let moreViewController = segue.destination as? MoreViewController {
                moreViewController.movieType = selectedMovieType
            }
        } else if segue.identifier == "moreUpcoming" {
            if let moreViewController = segue.destination as? MoreViewController {
                moreViewController.movieType = selectedMovieType
            }
        } else if segue.identifier == SegueId.moreGenresSegue {
            if let moreViewController = segue.destination as? MoreViewController {
                
               // moreViewController.movieType = selectedMovieType
                moreViewController.movieType = "moreGenres"
                moreViewController.selectedGenre = selectedGenre
                print("self.selectedGenre = \(self.selectedGenre)")
            }
        }
    }

    
}

extension GenresViewController: UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == dualCollectionView {
            
            if dualCollectionView == trendingCollectionView{
                print("TRENDING")
            } else if dualCollectionView == dailyTrendingCollectionView{
                print("DAILY")
            }
            return dataSourceTrendingMovies.count
            
            
        } else if collectionView == topRatedCollectionView {
            return dataSourceTopRatedMovies.count
            
        } else if collectionView == upcomingCollectionView {
            return dataSourceUpcomingMovies.count
            
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == dualCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCell", for: indexPath) as! TrendingMoviesCollectionViewCell
            cell.spiner.startAnimating()
            let posterName = dataSourceTrendingMovies[indexPath.row].posterPath
            
            cell.trendingImage.image = nil
            cell.trendingLabel.text = dataSourceTrendingMovies[indexPath.row].title
            print("dataSourceTrendingMovies = \(dataSourceTrendingMovies[indexPath.row].title)")
            
            ImageManager.getImageForPosterName(posterName, completion: { image in
                cell.trendingImage.image = image ?? UIImage(named: "question_mark")
            })
            
            func makePrint(){
                print("Success")
            }
            
            return cell
            
        } else if collectionView == topRatedCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TopRatedCell", for: indexPath) as! TopRatedCollectionViewCell
            cell.spiner.startAnimating()
            let posterName = dataSourceTopRatedMovies[indexPath.row].posterPath
            
            //Image need to be set when it seen by user - cache on collectionView level is working otherwise
            cell.topRatedImage.image = nil
            cell.topRatedLabel.text = dataSourceTopRatedMovies[indexPath.row].title
            
            ImageManager.getImageForPosterName(posterName, completion: { image in
                cell.topRatedImage.image = image ?? UIImage(named: "question_mark")
            })
            
            return cell
            
        } else if collectionView == upcomingCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCell", for: indexPath) as! UpcomingMoviesCollectionViewCell
            cell.spiner.startAnimating()
            
            
            
            let posterName: String
            
            let optionalPosterName = dataSourceUpcomingMovies[indexPath.row].posterPath
            
            if optionalPosterName == nil{
                posterName = ""
            } else {
                posterName = optionalPosterName!
                print("POSTER NAME = \(posterName)")
            }
            
            //Image need to be set when it seen by user - cache on collectionView level is working otherwise
            cell.upcomingImage.image = nil
            cell.upcomingLabel.text = dataSourceUpcomingMovies[indexPath.row].title
            
            ImageManager.getImageForPosterName(posterName, completion: { image in
                cell.upcomingImage.image = image ?? UIImage(named: "question_mark")
            })
            
            return cell
            
        }
        
        return TopRatedCollectionViewCell()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == dualCollectionView{
            mainDetailMovie = "trendingMovie"
            selectedTrendingMovie = dataSourceTrendingMovies[indexPath.row]
            performSegue(withIdentifier: SegueId.detailTrendingMovieSegue, sender: nil)
        } else if collectionView == topRatedCollectionView{
            mainDetailMovie = "topRatedMovie"
            selectedTopRatedMovie = dataSourceTopRatedMovies[indexPath.row]
            performSegue(withIdentifier: SegueId.detailTopRatedMovieSegue, sender: nil)
        } else if collectionView == upcomingCollectionView{
            mainDetailMovie = "upcomingMovie"
            selectedUpcomingMovie = dataSourceUpcomingMovies[indexPath.row]
            performSegue(withIdentifier: SegueId.detailUpcomingMovieSegue, sender: nil)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let trendingCell = cell as? TrendingMoviesCollectionViewCell else {
            return
        }
        
        let optionalPosterName = dataSourceTrendingMovies[indexPath.row].posterPath
        let posterName = optionalPosterName
        
        trendingCell.trendingImage.image = nil
        trendingCell.trendingLabel.text = dataSourceTrendingMovies[indexPath.row].title
        
        ImageManager.getImageForPosterName(posterName, completion: { image in
            trendingCell.trendingImage.image = image ?? UIImage(named: "question_mark")
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrayOfGenres = ["Action", "Comedy", "Family", "Science Fiction", "Triller"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenresCell", for: indexPath) as! GenresCollectionViewCell
        cell.genresLabel.text = arrayOfGenres[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovieType = "moreGenres"
        tableView.deselectRow(at: indexPath, animated: true)

        
        if indexPath.row == 0{
            selectedGenre = "Action"
        } else if indexPath.row == 1 {
            selectedGenre = "Comedy"
        } else if indexPath.row == 2 {
            selectedGenre = "Family"
        } else if indexPath.row == 3 {
            selectedGenre = "Science Fiction"
        } else if indexPath.row == 49 {
            selectedGenre = "Thriller"
        }
        
        tableView.cellForRow(at: indexPath)?.isSelected = false
        performSegue(withIdentifier: SegueId.moreGenresSegue, sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
}

extension GenresViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 160
        let height = 315
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
