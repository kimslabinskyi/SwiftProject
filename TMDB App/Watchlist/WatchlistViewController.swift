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

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        WatchlistData.shared.getData()
        mainCollectionView.reloadData()

    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueId.detailWatchlist{
            if let destinationVC = segue.destination as? DetailGenresViewController{
                destinationVC.detailedMovie = selectedWatchlistMovie
            }
        }
    }
    
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    //var watchlistMoviesDataSource: [WatchlistMovie] = []
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
            cell.cellImage.image = image ?? UIImage(named: "AppIcon")
        }
        
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedWatchlistMovie = WatchlistData.shared.watchlistMoviesDataSource[indexPath.row]
        performSegue(withIdentifier: SegueId.detailWatchlist, sender: nil)
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
