//
//  CollentionsViewController.swift
//  TMDB App
//
//  Created by KIm on 27.04.2023.
//

import UIKit
import Alamofire


class GenresViewController: UIViewController {
    
    let apiKey = "15ec7b54d43e199ced41a6e461173cee"
    @IBOutlet weak var trendingCollectionView: UICollectionView!
    
    
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    
    var dataSourceTrendingMovies: [TrendingMovie] = []
    var dataSourceTopRatedMovies: [TopRatedMovie] = []
    var selectedTrendingMovie: TrendingMovie?
    var selectedTopRatedMovie: TopRatedMovie?
    private var movies: TrendingMoviesResponse?
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("333")
        
        trendingCollectionView.showsHorizontalScrollIndicator = false
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.contentMode = .scaleAspectFit
        imageView.isLoading = true
        imageView.image = (UIImage(named: "Screenshot 2023-04-10 at 11.34.02"))
        
        fetchTrendingMovies()
        fetchTopRatedMovies()
        
        
    }
    
    private func fetchTrendingMovies() {
        NetworkManager.shared.getTrendingMovies {
            [weak self] trendingMoviesResponse in
            guard let self = self else { return }
            
            if let movies = trendingMoviesResponse {
                self.dataSourceTrendingMovies = movies.results
                self.trendingCollectionView.reloadData()
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
                print("Failed to fetch trending movies")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == SegueId.detailTrendingMovieSegue,
              let destinationVc = segue.destination as? DetailTrendingMovieViewController else {
            return
        }
        //        destinationVc.detailedTrendingMovie = selectedMovie
        destinationVc.detailedMovie = selectedTrendingMovie
    }
}

extension GenresViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == trendingCollectionView {
            return dataSourceTrendingMovies.count
        } else if collectionView == topRatedCollectionView {
            return dataSourceTopRatedMovies.count
            
        }
        return 0
    }
    


func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if collectionView == trendingCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCell", for: indexPath) as! TrendingMoviesCollectionViewCell
        cell.spiner.startAnimating()
        let posterName = dataSourceTrendingMovies[indexPath.row].posterPath
        
        //Image need to be set when it seen by user - cache on collectionView level is working otherwise
        cell.trendingImage.image = nil
        
        ImageManager.getImageForPosterName(posterName, completion: { image in
            cell.trendingImage.image = image ?? UIImage(named: "AppIcon")
        })
        
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
        
    }
    return TopRatedCollectionViewCell()
}
    
    


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == trendingCollectionView{
            selectedTrendingMovie = dataSourceTrendingMovies[indexPath.row]
            performSegue(withIdentifier: SegueId.detailTrendingMovieSegue, sender: nil)
        } else if collectionView == topRatedCollectionView{
            selectedTopRatedMovie = dataSourceTopRatedMovies[indexPath.row]
                performSegue(withIdentifier: SegueId.detailTrendingMovieSegue, sender: nil)
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
