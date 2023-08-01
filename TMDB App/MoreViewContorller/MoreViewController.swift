//
//  MoreWeekTrendingViewController.swift
//  TMDB App
//
//  Created by KIm on 19.07.2023.
//

import UIKit

class MoreViewController: UIViewController {
    
    
    
    
    
    // IMAGE MANAGER
    
    // Detail Screen
    // Genres Controller
    
    
    
    
    //MARK: CollectionView
    
    @IBOutlet weak var MoreCollectionView: UICollectionView!
    var dataSourceTrendingMovies: [TrendingMovie] = []
    var dataSourceTopRatedMovies: [TopRatedMovie] = []
    var dataSourceUpcomingMovies: [UpcomingMovie] = []
    var selectedTrendingMovie: TrendingMovie?
    var selectedTopRatedMovie: TopRatedMovie?
    var selectedUpcomingMovie: UpcomingMovie?
    var movieType: String?
    
    var page = 2
    let collectionIndexPath = IndexPath(item: 0, section: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SELECTEDMOVIE = \(movieType)")
        MoreCollectionView.dataSource = self
        MoreCollectionView.delegate = self
        previousPageButton.isHidden = true
        
        if movieType == "trending"{
            mainLabel.text = "Trending Movies"
            fetchMoreTrendingMovies()
        } else if movieType == "topRated" {
            mainLabel.text = "TopRated"
            fetchMoreTopRatedMovies()
        } else if movieType == "upcoming"{
            mainLabel.text = "UpcomingMovies"
            fetchMoreUpcomingMovies()
        }
        
        
        previousPageButton.addTarget(self, action: #selector(previousPageButtonTapped), for: .touchUpInside)
        nextPageButton.addTarget(self, action: #selector(nextPageButtonTapped), for: .touchUpInside)
        
        
        
        
    }
    
    
    @IBOutlet weak var mainLabel: UILabel!
    
    
    
    
    
    //MARK: Buttons
    
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var previousPageButton: UIButton!
    
    @objc func nextPageButtonTapped(_ sender: Any) {
        page += 1
        print("page = \(page)")
        previousPageButton.isHidden = false
        fetchMoreTrendingMovies()
        MoreCollectionView.reloadData()
        
        MoreCollectionView.scrollToItem(at: collectionIndexPath, at: .top, animated: true)
        
    }
    
    @objc func previousPageButtonTapped() {
        print("Button tapped!")
        if page == 2 {
            previousPageButton.isHidden = true
        } else {
            page -= 1
            fetchMoreTrendingMovies()
            MoreCollectionView.reloadData()
            MoreCollectionView.scrollToItem(at: collectionIndexPath, at: .top, animated: true)
            
        }
        
    }
    
    @objc func buttonTapped() {
        // Блок кода, который выполнится через 2 секунды после нажатия на кнопку
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Ваш код здесь
            print("Кнопка была нажата с задержкой в 2 секунды.")
        }
    }
    
    private func fetchMoreTrendingMovies() {
        NetworkManager.shared.getTrendingMovies(page: page) {
            [weak self] trendingMoviesResponse in
            guard let self = self else { return }
            print("page in request = \(page)")
            
            if let movies = trendingMoviesResponse {
                self.dataSourceTrendingMovies = movies.results
                self.MoreCollectionView.reloadData()
            } else {
                print("Failed to fetch trending movies")
            }
        }
    }
    
    private func fetchMoreTopRatedMovies() {
        NetworkManager.shared.getTopRatedMovies(page: page) {
            [weak self] trendingMoviesResponse in
            guard let self = self else { return }
            print("page in request = \(page)")
            
            if let movies = trendingMoviesResponse {
                self.dataSourceTopRatedMovies = movies.results
                self.MoreCollectionView.reloadData()
            } else {
                print("Failed to fetch trending movies")
            }
        }
    }
    
    
    private func fetchMoreUpcomingMovies() {
        NetworkManager.shared.getUpcomingMovies(page: page) {
            [weak self] trendingMoviesResponse in
            guard let self = self else { return }
            print("page in request = \(page)")
            
            if let movies = trendingMoviesResponse {
                self.dataSourceUpcomingMovies = movies.results
                self.MoreCollectionView.reloadData()
            } else {
                print("Failed to fetch trending movies")
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailTrendingMovieSegue" {
            if let destinationVC = segue.destination as? DetailGenresViewController {
                
                destinationVC.detailedMovie = selectedTrendingMovie
                
            }
        } else if segue.identifier == "DetailTopRatedMovieSegue" {
            if let destinationVC = segue.destination as? DetailGenresViewController {
                
                destinationVC.detailedMovie = selectedTopRatedMovie
                
            }
            
        } else if segue.identifier == "DetailUpcomingMovieSegue" {
            if let destinationVC = segue.destination as? DetailGenresViewController {
                
                destinationVC.detailedMovie = selectedUpcomingMovie
                
            }
        }
    }
    
    
}


extension MoreViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if movieType == "trending" {
            return dataSourceTrendingMovies.count
        } else if movieType == "topRated" {
            return dataSourceTopRatedMovies.count
        } else if movieType == "upcoming" {
            return dataSourceUpcomingMovies.count
        }
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreCell", for: indexPath) as! MoreCollectionViewCell
        
        
        if movieType == "trending" {
            
            let posterName = dataSourceTrendingMovies[indexPath.row].posterPath
            
            
            cell.moreImageView.image = nil
            cell.moreLabel.text = dataSourceTrendingMovies[indexPath.row].originalTitle
            cell.spinner.startAnimating()
            
            ImageManager.getImageForPosterName(posterName) { image in
                cell.moreImageView.image = image ?? UIImage(named: "AppIcon")
                
            }
            
            
            return cell
            
            
        } else if movieType == "topRated" {
            
            
            let posterName = dataSourceTopRatedMovies[indexPath.row].posterPath
            
            
            cell.moreImageView.image = nil
            cell.moreLabel.text = dataSourceTopRatedMovies[indexPath.row].originalTitle
            cell.spinner.startAnimating()
            
            ImageManager.getImageForPosterName(posterName) { image in
                cell.moreImageView.image = image ?? UIImage(named: "AppIcon")
                
            }
            
            
            return cell
            
            
        } else if movieType == "upcoming" {
            
            
            
            let posterName = dataSourceUpcomingMovies[indexPath.row].posterPath
            
            
            cell.moreImageView.image = nil
            cell.moreLabel.text = dataSourceUpcomingMovies[indexPath.row].originalTitle
            cell.spinner.startAnimating()
            
            ImageManager.getImageForPosterName(posterName) { image in
                cell.moreImageView.image = image ?? UIImage(named: "AppIcon")
                
            }
            
            
            return cell
            
        }
        
        
        
        
        return cell
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if movieType == "trending"{
            //mainDetailMovie = "trendingMovie"
            
            selectedTrendingMovie = dataSourceTrendingMovies[indexPath.row]
            //navigateToDetailViewController()
            performSegue(withIdentifier: SegueId.detailTrendingMovieSegue, sender: nil)
            
        } else if movieType == "topRated"{
            selectedTopRatedMovie = dataSourceTopRatedMovies[indexPath.row]
            performSegue(withIdentifier: SegueId.detailTopRatedMovieSegue, sender: nil)
        } else if movieType == "upcoming" {
            selectedUpcomingMovie = dataSourceUpcomingMovies[indexPath.row]
            performSegue(withIdentifier: SegueId.detailUpcomingMovieSegue, sender: nil)
        }
    }
    
}


extension MoreViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 168
        let height = 258
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
