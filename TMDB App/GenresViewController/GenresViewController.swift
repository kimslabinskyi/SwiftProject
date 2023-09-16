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
    
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    @IBOutlet weak var genresCollectionView: UICollectionView!
    
    
    let apiKey = "15ec7b54d43e199ced41a6e461173cee"
    var mainDetailMovie: String?
    var selectedMovieType: String?
    
    var dataSourceTrendingMovies: [TrendingMovie] = []
    var dataSourceTopRatedMovies: [TopRatedMovie] = []
    var dataSourceUpcomingMovies: [UpcomingMovie] = []
    var dataSourceGenresMovies: [GenreMovie] = []
    var dataSourceDailyTrendingMovies: [DailyTrendingMovie] = []
    
    var selectedTrendingMovie: TrendingMovie?
    var selectedTopRatedMovie: TopRatedMovie?
    var selectedUpcomingMovie: UpcomingMovie?
    var selectedGenreMovie: GenreMovie?
    var selectedDailyTrendingMovie: DailyTrendingMovie?
    
    let trendingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let dailyTrendingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var tempCollectionView: UICollectionView?
    var selectedGenre: String?
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        trendingCollectionView.register(TrendingMoviesCollectionViewCell.self, forCellWithReuseIdentifier: "TrendingCell")
        dailyTrendingCollectionView.register(DayTrendingCollectionViewCell.self, forCellWithReuseIdentifier: "DayTrendingCell")
        
        
        
        dualCollectionView.showsHorizontalScrollIndicator = false
        topRatedCollectionView.showsHorizontalScrollIndicator = false
        upcomingCollectionView.showsHorizontalScrollIndicator = false
        genresCollectionView.showsVerticalScrollIndicator = false
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .scaleAspectFit
        imageView.isLoading = true
        imageView.image = (UIImage(named: "AppIcon"))
        
        fetchTrendingMovies()
        fetchTopRatedMovies()
        fetchUpcomingMovies()
        //fetchDailyTrendingMovies()
    }
    
    
    
    
    //MARK: IBAction func's
    
    @IBAction func segmentControllAction(_ sender: UISegmentedControl){
        switch segmentedControll.selectedSegmentIndex{
        case 0: print("SEGMENT = 0")
            //            dualCollectionView = trendingCollectionView
            //            dualCollectionView.reloadData()
            tempCollectionView = trendingCollectionView
            trendingCollectionView.isHidden = false
            dailyTrendingCollectionView.isHidden = true
            tempCollectionView?.reloadData()
            dualCollectionView.reloadData()
            
        case 1:
            print("SEGMENT = 1")
            //            dualCollectionView = dailyTrendingCollectionView
            //            dualCollectionView.reloadData()
            tempCollectionView = dailyTrendingCollectionView
            trendingCollectionView.isHidden = true
            dailyTrendingCollectionView.isHidden = false
            tempCollectionView?.reloadData()
            dualCollectionView.reloadData()
        default:
            print("Error with UISegmentedControl")
        }
    }
    
    
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
    
    
    
    //MARK: Fetch Movies
    
    private func fetchTrendingMovies() {
        NetworkManager.shared.getTrendingMovies(page: 1, language: "uk-UA") {
            
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
    
    private func fetchDailyTrendingMovies(){
        NetworkManager.shared.getDailyTrendingMovies{
            [weak self] DailyTrendingMoviesResponse in
            guard let self = self else { return }
            
            if let movies = DailyTrendingMoviesResponse {
                self.dataSourceDailyTrendingMovies = movies.results
                self.dailyTrendingCollectionView.reloadData()
            } else {
                print("Failed to fetch daily trending movies")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailTrendingMovieSegue" {
            if let destinationVC = segue.destination as? DetailGenresViewController {
                
                destinationVC.detailedMovie = selectedTrendingMovie
                
            }
            
        } else if segue.identifier == "DetailTopRatedMovieSegue"{
            if let destinationVC = segue.destination as? DetailGenresViewController {
                
                destinationVC.detailedMovie = selectedTopRatedMovie
                
            }
            
        } else if segue.identifier == "DetailUpcomingMovieSegue" {
            if let destinationVC = segue.destination as? DetailGenresViewController {
                
                // destinationVC.detailedTrendingMovie = selectedTrendingMovie
                destinationVC.detailedMovie = selectedUpcomingMovie
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

extension GenresViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
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
            
        } else if collectionView == genresCollectionView {
            return 6
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == dualCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCell", for: indexPath) as! TrendingMoviesCollectionViewCell
            cell.spiner.startAnimating()
            let posterName = dataSourceTrendingMovies[indexPath.row].posterPath
            
            cell.trendingImage.image = nil
            cell.trendingLabel.text = dataSourceTrendingMovies[indexPath.row].originalTitle
            print("dataSourceTrendingMovies = \(dataSourceTrendingMovies[indexPath.row].title)")
            
            ImageManager.getImageForPosterName(posterName, completion: { image in
                cell.trendingImage.image = image ?? UIImage(named: "AppIcon")
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
                cell.topRatedImage.image = image ?? UIImage(named: "AppIcon")
            })
            
            return cell
            
        } else if collectionView == dailyTrendingCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyTrendingCell", for: indexPath) as! DayTrendingCollectionViewCell
            print("code: 4")
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
                cell.upcomingImage.image = image ?? UIImage(named: "AppIcon")
            })
            
            return cell
            
        } else if collectionView == genresCollectionView {
            let arrayOfGenres = ["Action", "Comedy", "Family", "Fantasy","Science Fiction", "Triller"]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCell", for: indexPath) as! GenresCollectionViewCell
            cell.genresImage.image = UIImage(named: "AppIcon")
            cell.genresLabel.text = arrayOfGenres[indexPath.row]
            return cell
        }
        return TopRatedCollectionViewCell()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == dualCollectionView{
            mainDetailMovie = "trendingMovie"
            
            selectedTrendingMovie = dataSourceTrendingMovies[indexPath.row]
            //navigateToDetailViewController()
            performSegue(withIdentifier: SegueId.detailTrendingMovieSegue, sender: nil)
        } else if collectionView == topRatedCollectionView{
            mainDetailMovie = "topRatedMovie"
            selectedTopRatedMovie = dataSourceTopRatedMovies[indexPath.row]
            performSegue(withIdentifier: SegueId.detailTopRatedMovieSegue, sender: nil)
        } else if collectionView == upcomingCollectionView{
            mainDetailMovie = "upcomingMovie"
            selectedUpcomingMovie = dataSourceUpcomingMovies[indexPath.row]
            performSegue(withIdentifier: SegueId.detailUpcomingMovieSegue, sender: nil)
        } else if collectionView == genresCollectionView{
            selectedMovieType = "moreGenres"
            
            if indexPath.row == 0{
                selectedGenre = "Action"
            } else if indexPath.row == 1 {
                selectedGenre = "Comedy"
            } else if indexPath.row == 2 {
                selectedGenre = "Family"
            } else if indexPath.row == 3 {
                selectedGenre = "Fantasy"
            } else if indexPath.row == 4 {
                selectedGenre = "Science Fiction"
            } else if indexPath.row == 5 {
                selectedGenre = "Thriller"
            }
            
            
            performSegue(withIdentifier: SegueId.moreGenresSegue, sender: nil)
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let trendingCell = cell as? TrendingMoviesCollectionViewCell else {
                return
            }
            
            let optionalPosterName = dataSourceTrendingMovies[indexPath.row].posterPath
            let posterName = optionalPosterName ?? ""
            
            trendingCell.trendingImage.image = nil
            trendingCell.trendingLabel.text = dataSourceTrendingMovies[indexPath.row].title
            
            ImageManager.getImageForPosterName(posterName, completion: { image in
                trendingCell.trendingImage.image = image ?? UIImage(named: "AppIcon")
            })
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
