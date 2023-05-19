//
//  FavoritesViewController.swift
//  TMDB App
//
//  Created by KIm on 01.05.2023.
//

import UIKit
import Alamofire

class FavoritesViewController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: [Movie] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        collectionView.showsHorizontalScrollIndicator = false
        
        NetworkManager.shared.getFavoriteMovies { [weak self] movieResponse in
            guard let self = self else { return }
            
            if let movieResponse = movieResponse {
                self.dataSource = movieResponse.results
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
}


extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MoviesCollectionViewCell
        
        let posterName = dataSource[indexPath.row].posterPath ?? ""
        if let url = URL(string: "https://www.themoviedb.org/t/p/original/\(posterName)") {
            loadImageUsingAlamofire(from: url) { image in
                cell.movieImageView.image = image
            }
        }else {
            cell.movieImageView.image = UIImage(named: "AppIcon")
        }
        cell.movieLabel.text = dataSource[indexPath.row].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailMovieInfoSegue", sender: nil)
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 200
        let height = 230
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

/*
 extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate{
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 if section == 0 {
 // Верните количество ячеек для первой секции
 return 3
 } else if section == 1 {
 // Верните количество ячеек для второй секции
 return 2
 }
 
 return 0
 }
 
 
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
 let cell = tableView .dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
 
 
 if indexPath.section == 0 {
 
 cell.textLabel?.text = "Section 1, Row \(indexPath.row)"
 
 //            favouriteMoviesCount.count
 } else if indexPath.section == 1 {
 // Настройте содержимое ячейки для второй секции
 cell.textLabel?.text = "Section 2, Row \(indexPath.row)"
 }
 
 
 // cell.textLabel?.text = tableViewNames[indexPath.row]
 return cell
 }
 
 func numberOfSections(in tableView: UITableView) -> Int {
 return 2
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
 
 
 
 performSegue(withIdentifier: "DetailMovieInfoSegue", sender: nil)
 
 }
 }
 */



