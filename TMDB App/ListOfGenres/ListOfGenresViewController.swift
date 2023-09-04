//
//  ListOfGenresViewController.swift
//  TMDB App
//
//  Created by KIm on 08.08.2023.
//

import UIKit

class ListOfGenresViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBOutlet weak var listOfGenresTableView: UITableView!
    
    var selectedGenre: String?
    let genres =
     ["Adventure",
      "Animation",
      "Crime",
      "Drama",
      "History",
      "Horror",
      "Music",
      "Romance",
      "TV Movie",
      "War",
      "Western" ]

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moreGenres"{
            if let moreViewController = segue.destination as? MoreViewController {
                
                moreViewController.movieType = "moreGenres"
                moreViewController.selectedGenre = selectedGenre
                print("self.selectedGenre = \(self.selectedGenre)")
            }
        }
    }

}


extension ListOfGenresViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell") as! GenresTableViewCell
        cell.listLabel.text = genres[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
          //  selectedMovieType = "moreGenres"
            
            if indexPath.row == 0 {
                selectedGenre = "Adventure"
            } else if indexPath.row == 1 {
                selectedGenre = "Animation"
            } else if indexPath.row == 2 {
                selectedGenre = "Crime"
            } else if indexPath.row == 3 {
                selectedGenre = "Drama"
            } else if indexPath.row == 4 {
                selectedGenre = "History"
            } else if indexPath.row == 5 {
                selectedGenre = "Horror"
            } else if indexPath.row == 6 {
                selectedGenre = "Music"
            } else if indexPath.row == 7 {
                selectedGenre = "Romance"
            } else if indexPath.row == 8 {
                selectedGenre = "TV Movie"
            } else if indexPath.row == 9 {
                selectedGenre = "War"
            } else if indexPath.row == 10 {
                selectedGenre = "Western"
            }
            
            
            performSegue(withIdentifier: "moreGenres", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                return 65
        }
    
    
    
}


