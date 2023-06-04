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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: [TrendingMovie] = []
    var selectedMovie: TrendingMovie?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("333")
        collectionView.showsHorizontalScrollIndicator = false
        
//        NetworkManager.shared.getFavoriteMovies { [weak self] movieResponse in
//            guard let self = self else { return }
//
//            if let movieResponse = movieResponse {
//                self.dataSource = movieResponse.results
//                self.collectionView.reloadData()
//            }
//        }
        
                NetworkManager.shared.getTrendingMovies { [weak self] movieResponse in
                    guard let self = self else { return }
        
                    print("MOVIE RESOPONSE = \(movieResponse)")
                    print("self.dataSource = \(self.dataSource)")
                    if let movieResponse = movieResponse {
                        //self.dataSource = movieResponse.results
                        self.collectionView.reloadData()
                    }
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
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard segue.identifier == SegueId.detailTrendingMovieSegue,
                  let destinationVc = segue.destination as? DetailTrendingMovieViewController else {
                return
            }
            //        destinationVc.detailedTrendingMovie = selectedMovie
            destinationVc.detailedMovie = selectedMovie
            
        }
        
        
        
    }



extension GenresViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrendingCell", for: indexPath) as! TrendingMoviesCollectionViewCell
        
        let posterName = dataSource[indexPath.row].posterPath ?? ""
        if let url = URL(string: "https://www.themoviedb.org/t/p/original/\(posterName)") {
            loadImageUsingAlamofire(from: url) { image in
                cell.trendingImage.image = image
            }
        }else {
            cell.trendingImage.image = UIImage(named: "AppIcon")
        }
        
     
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = dataSource[indexPath.row]
        performSegue(withIdentifier: SegueId.detailFavouriteMovieInfoSegue, sender: nil)
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
