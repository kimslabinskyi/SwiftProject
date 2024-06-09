//
//  FoundMoviesCollectionViewController.swift
//  TMDB App
//
//  Created by Kim on 14.04.2024.
//

import UIKit

class FoundMoviesCollectionViewController: UIViewController {
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    var listOfMovies: [FoundMovie] = []
    var selectedFoundMovie: FoundMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  mainCollectionView.register(FoundMovieCollectionViewCell.self, forCellWithReuseIdentifier: "FoundMoviesCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueId.detailFoundMovieSegue{
            if let destinationVC = segue.destination as? DetailGenresViewController{
                destinationVC.detailedMovie = selectedFoundMovie
            }
        }
    }
    
}
    
    
    
extension FoundMoviesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return listOfMovies.count
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoundMoviesCell", for: indexPath) as! FoundMovieCollectionViewCell

        let posterName = listOfMovies[indexPath.row].posterPath
        cell.cellImage.image = nil
        cell.cellLabel.text = listOfMovies[indexPath.row].title
        cell.spinner.startAnimating()
       
        ImageManager.getImageForPosterName(posterName) { image in
                cell.cellImage.image = image ?? UIImage(named: "question_mark")
            
        }
       
       return cell
   }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFoundMovie = listOfMovies[indexPath.row]
        performSegue(withIdentifier: SegueId.detailFoundMovieSegue, sender: nil)
    }

    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let foundCell = cell as? FoundMovieCollectionViewCell else {
            return
        }
        
        let optionalPosterName = listOfMovies[indexPath.row].posterPath
        let posterName = optionalPosterName ?? ""
        
        foundCell.cellImage.image = nil
        foundCell.cellLabel.text = listOfMovies[indexPath.row].title
        
        ImageManager.getImageForPosterName(posterName, completion: {
            image in
            foundCell.cellImage.image = image ?? UIImage(named: "question_mark")
        })
    }
}



extension FoundMoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
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
