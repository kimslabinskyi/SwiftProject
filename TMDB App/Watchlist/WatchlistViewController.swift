//
//  WatchlistViewController.swift
//  TMDB App
//
//  Created by Kim on 25.04.2024.
//

import UIKit

class WatchlistViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        WatchlistData.shared.getData()
        mainCollectionView.showsVerticalScrollIndicator = false
        mainCollectionView.reloadData()
        if WatchlistData.shared.watchlistMoviesDataSource.isEmpty{
            let alertController = UIAlertController(title: "Your list is empty", message: "You can add any movie to your watchlist!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        WatchlistData.shared.getData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            self.mainCollectionView.reloadData()
        }

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueId.detailWatchlist{
            if let destinationVC = segue.destination as? DetailGenresViewController{
                destinationVC.detailedMovie = selectedWatchlistMovie
                
                if WatchlistData.shared.watchlistData.contains(selectedWatchlistMovie?.id ?? 0){
                    print("success")
                    destinationVC.receivedWatchlistValue = true
                }
            }
        }
    }
    
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    var selectedWatchlistMovie: WatchlistMovie?
    

}


extension WatchlistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        WatchlistData.shared.watchlistMoviesDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WatchlistCell", for: indexPath) as! WatchlistCollectionViewCell
        
        let posterName = WatchlistData.shared.watchlistMoviesDataSource[indexPath.row].posterPath
        cell.cellImage.image = nil
        cell.cellLabel.text = WatchlistData.shared.watchlistMoviesDataSource[indexPath.row].title
        cell.spinner.startAnimating()
        
        ImageManager.getImageForPosterName(posterName){
            image in
            cell.cellImage.image = image ?? UIImage(named: "question_mark")
        }
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < WatchlistData.shared.watchlistMoviesDataSource.count {
            selectedWatchlistMovie = WatchlistData.shared.watchlistMoviesDataSource[indexPath.row]
            performSegue(withIdentifier: SegueId.detailWatchlist, sender: nil)
        } else {
            print("Index out of range!")
        }
    }

    
    
    
}


extension WatchlistViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 160
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
