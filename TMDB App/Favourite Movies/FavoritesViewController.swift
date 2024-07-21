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
    
    var dataSource: [FavouriteMovie] = []
    var selectedFavouriteMovie: FavouriteMovie?
    let currentPage = 1

    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        setUp()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            ListOfFavouritesMovies.shared.getList()
            self.setUp()
            self.collectionView.reloadData()
            
            if self.dataSource.isEmpty{
                self.showAlert()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    
    
    func setUp(){
        NetworkManager.shared.getFavoriteMovies() { [weak self] movieResponse, arg  in
            guard let self = self else { return }
            
            if let movieResponse = movieResponse {
                self.dataSource = movieResponse.results
                self.collectionView.reloadData()
            }
        }
    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "Your list is empty", message: "You can add any movie to your favourites list! ", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailFavouriteMovieInfoSegue"{
            if let destinationVC = segue.destination as? DetailGenresViewController {
                destinationVC.detailedMovie = selectedFavouriteMovie
                
                if ListOfFavouritesMovies.shared.listOfFavouritesMovies.contains(selectedFavouriteMovie?.id ?? 0){
                    destinationVC.receivedFavouriteValue = true
                }
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
        cell.spiner.startAnimating()
        let posterName = dataSource[indexPath.row].posterPath
        
        cell.movieImageView.image = nil
        
        ImageManager.getImageForPosterName(posterName, completion: {
            image in
            cell.movieImageView.image = image ?? UIImage(named: "question_mark")
        })
        
        
        
        cell.movieLabel.text = dataSource[indexPath.row].title
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFavouriteMovie = dataSource[indexPath.row]
        performSegue(withIdentifier: SegueId.detailFavouriteMovieInfoSegue, sender: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? FoundMovieCollectionViewCell else {
            return
        }
        
        let optionalPosterName = ListOfFavouritesMovies.shared.dataSourceFavouritesMovies[indexPath.row].posterPath
        let posterName = optionalPosterName
        
        cell.cellImage.image = nil
        cell.cellLabel.text = ListOfFavouritesMovies.shared.dataSourceFavouritesMovies[indexPath.row].title
        
        ImageManager.getImageForPosterName(posterName, completion: { image in
            cell.cellImage.image = image ?? UIImage(named: "question_mark") })
    }
    
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 160
        let height = 270
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
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



