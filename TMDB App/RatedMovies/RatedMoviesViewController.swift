//
//  RatedMoviesViewController.swift
//  TMDB App
//
//  Created by Kim on 03.05.2024.
//

import UIKit

class RatedMoviesViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // WatchlistData.shared.getData()
        RatedMoviesData.shared.getData(page: 1)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        if RatedMoviesData.shared.dataSourceRatedMovies.count < 20 {
            nextPageButton.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        pageNumber = 1
        RatedMoviesData.shared.getData(page: pageNumber)
        
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueId.changeRatingSegue{
            if let destinationVC = segue.destination as? RateScreenViewController{
                destinationVC.receivedPosterURL = selectedMovie?.posterURL
                destinationVC.receivedMovieID = selectedMovie?.moviesIDS
                destinationVC.receivedVoteAverage = String(selectedMovie?.voteAverage ?? 0.0)
                destinationVC.receivedLabel = selectedMovie?.title
            }
        }
    }
    
    func setUp(){
        previousPageButton.isHidden = true
        previousPageButton.addTarget(self, action: #selector(previousPageButtonTapped), for: .touchUpInside)
        nextPageButton.addTarget(self, action: #selector(nextPageButtonTapped), for: .touchUpInside)
        tableView.showsVerticalScrollIndicator = false
        
        if WatchlistData.shared.watchlistMoviesDataSource.isEmpty{
            let alertController = UIAlertController(title: "Your list is empty", message: "You can add rating to any movie!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var nextPageButton: UIButton!
    @IBOutlet weak var previousPageButton: UIButton!
    @IBOutlet weak var pageCounterLabel: UILabel!

    var selectedMovie: RatedMovie?
    var isButtonHide: Bool?
    var pageNumber = 1
    let desiredIndexPath = IndexPath(row: 0, section: 0)

    
    @objc func nextPageButtonTapped(_ sender: Any) {
        if RatedMoviesData.shared.dataSourceRatedMovies.count == 20 {
            
            tableView.isScrollEnabled = false
            nextPageButton.isHidden = false
            previousPageButton.isHidden = false
            pageNumber += 1
            print("page = \(pageNumber)")
            isButtonHide = true

            RatedMoviesData.shared.getData(page: pageNumber)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.tableView.reloadData()
                self.tableView.isScrollEnabled = true
                
                if RatedMoviesData.shared.dataSourceRatedMovies.count < 20 {
                    self.nextPageButton.isHidden = true
                }
            }
            
            pageCounterLabel.text = "\(pageNumber)"
            tableView.scrollToRow(at: desiredIndexPath, at: .top, animated: true)
            
        }
    }
    
    
    
    @objc func previousPageButtonTapped() {
        print("Button tapped!")
        if pageNumber == 1 {
            previousPageButton.isHidden = true
        } else {
            if isButtonHide == true && pageNumber == 2 {
                previousPageButton.isHidden = true
                    }
            
                        isButtonHide = true
            pageNumber -= 1
            RatedMoviesData.shared.getData(page: pageNumber)
            
            pageCounterLabel.text = "\(pageNumber)"
            tableView.scrollToRow(at: desiredIndexPath, at: .top, animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.tableView.reloadData()
               
                if RatedMoviesData.shared.dataSourceRatedMovies.count == 20 {
                    self.nextPageButton.isHidden = false
                }
            }

        }
        
    }
    
   
}


extension RatedMoviesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RatedMoviesData.shared.dataSourceRatedMovies.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatedCell") as! RatedMoviesTableViewCell
        if indexPath.row < RatedMoviesData.shared.dataSourceRatedMovies.count {
            cell.mainLabel.text = RatedMoviesData.shared.dataSourceRatedMovies[indexPath.row].title
        } else {
            print("Index out of range!")
        }
        
        let posterName = RatedMoviesData.shared.dataSourceRatedMovies[indexPath.row].posterPath
        ImageManager.getImageForPosterName(posterName){
            image in
            cell.mainImage.image = image ?? UIImage(named: "question_mark")
        }
        
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < RatedMoviesData.shared.dataSourceRatedMovies.count {
            selectedMovie = RatedMoviesData.shared.dataSourceRatedMovies[indexPath.row]
            performSegue(withIdentifier: SegueId.changeRatingSegue, sender: nil)
        } else {
            print("Index out of range!")
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let ratedCell = cell as? RatedMoviesTableViewCell else {
            return
        }

        ratedCell.mainLabel.text = RatedMoviesData.shared.dataSourceRatedMovies[indexPath.row].title
        
        let posterName = RatedMoviesData.shared.dataSourceRatedMovies[indexPath.row].posterPath
        ImageManager.getImageForPosterName(posterName) { image in
            ratedCell.mainImage.image = image ?? UIImage(named: "question_mark")
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let movieId = RatedMoviesData.shared.dataSourceRatedMovies[indexPath.row].id

            RatedMoviesData.shared.dataSourceRatedMovies.remove(at: indexPath.row)
            NetworkManager.shared.deleteRatedMovie(movieID: movieId) { result in
                switch result {
                case .success (let response):
                    print(response.statusCode)
                    print(response.statusMessage)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
            self.tableView.endUpdates()
        }
    }
    
}
