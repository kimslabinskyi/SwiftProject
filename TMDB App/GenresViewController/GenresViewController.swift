//
//  CollentionsViewController.swift
//  TMDB App
//
//  Created by KIm on 27.04.2023.
//

import UIKit
import Alamofire

protocol GenresViewControllerDelegate: AnyObject {
    func didSelectMovie(_ movie: String)
}

class GenresViewController: UIViewController, GenresViewControllerDelegate {
    
    @IBOutlet weak var dualCollectionView: UICollectionView!

    
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    let apiKey = "15ec7b54d43e199ced41a6e461173cee"
    var mainDetailMovie: String?
    weak var delegate: GenresViewControllerDelegate?
    
    var dataSourceTrendingMovies: [TrendingMovie] = []
    var dataSourceTopRatedMovies: [TopRatedMovie] = []
    var dataSourceUpcomingMovies: [UpcomingMovie] = []
    var dataSourceDailyTrendingMovies: [DailyTrendingMovie] = []
    
    var selectedTrendingMovie: TrendingMovie?
    var selectedTopRatedMovie: TopRatedMovie?
    var selectedUpcomingMovie: UpcomingMovie?
    var selectedDailyTrendingMovie: DailyTrendingMovie?
    
    let trendingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let dailyTrendingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var tempCollectionView: UICollectionView?
    
    
    
    
    
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
    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        delegate?.didSelectMovie("trendingMovie")


        // Регистрация классов ячеек для trendingCollectionView и dailyTrendingCollectionView
        trendingCollectionView.register(TrendingMoviesCollectionViewCell.self, forCellWithReuseIdentifier: "TrendingCell")
        dailyTrendingCollectionView.register(DayTrendingCollectionViewCell.self, forCellWithReuseIdentifier: "DayTrendingCell")

        
        
        dualCollectionView.showsHorizontalScrollIndicator = false
        topRatedCollectionView.showsHorizontalScrollIndicator = false
        upcomingCollectionView.showsHorizontalScrollIndicator = false
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .scaleAspectFit
        imageView.isLoading = true
        imageView.image = (UIImage(named: "AppIcon"))
        
        fetchTrendingMovies()
        fetchTopRatedMovies()
        fetchUpcomingMovies()
        fetchDailyTrendingMovies()
    }
    
    private func fetchTrendingMovies() {
        NetworkManager.shared.getTrendingMovies {
            
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
        NetworkManager.shared.getTopRatedMovies {
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
        NetworkManager.shared.getUpcomingMovies {
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
    
    func fetchDailyTrendingMovies(){
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
            if let destinationVC = segue.destination as? DetailTrendingMovieViewController {

                destinationVC.detailedMovie = selectedTrendingMovie
                            destinationVC.someProperty = "Some value"
                }

        } else {
            print("Identifier is not correct!")
        }


//        guard segue.identifier == SegueId.detailTrendingMovieSegue,
//              let destinationVc = segue.destination as? DetailTrendingMovieViewController else {
//            return
//        }
//        //        destinationVc.detailedTrendingMovie = selectedMovie
//        destinationVc.detailedMovie = selectedTrendingMovie
    }
    
    func didSelectMovie(_ movie: String) {
        delegate?.didSelectMovie(movie)
    }
    
//    func navigateToDetailViewController() {
//        let detailVC = DetailTrendingMovieViewController()
//        detailVC.delegate = self
//        navigationController?.pushViewController(detailVC, animated: true)
//    }

    
    
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
        }
        return 0
    }
    

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView == dualCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCell", for: indexPath) as! TrendingMoviesCollectionViewCell
        cell.spiner.startAnimating()
        let posterName = dataSourceTrendingMovies[indexPath.row].posterPath
        
        cell.trendingImage.image = nil
        
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
        
        ImageManager.getImageForPosterName(posterName, completion: { image in
            cell.topRatedImage.image = image ?? UIImage(named: "AppIcon")
        })
        
        return cell
        
    } else if collectionView == dailyTrendingCollectionView {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyTrendingCell", for: indexPath) as! DayTrendingCollectionViewCell
        // Конфигурация ячейки DayTrendingCollectionViewCell
        print("code: 4")
        return cell
    } else if collectionView == upcomingCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCell", for: indexPath) as! UpcomingMoviesCollectionViewCell
        cell.spiner.startAnimating()
        let posterName = dataSourceUpcomingMovies[indexPath.row].posterPath
        
        //Image need to be set when it seen by user - cache on collectionView level is working otherwise
        cell.upcomingImage.image = nil
        
        ImageManager.getImageForPosterName(posterName, completion: { image in
            cell.upcomingImage.image = image ?? UIImage(named: "AppIcon")
        })
        
        return cell
        
    }
    return TopRatedCollectionViewCell()
}
    
    


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == dualCollectionView{
            delegate?.didSelectMovie("trendingMovie")
            mainDetailMovie = "trendingMovie"
            
            selectedTrendingMovie = dataSourceTrendingMovies[indexPath.row]
            //navigateToDetailViewController()
                // performSegue(withIdentifier: SegueId.detailTrendingMovieSegue, sender: nil)
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
}

extension GenresViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 160
        let height = 260
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
