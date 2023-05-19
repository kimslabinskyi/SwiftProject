//
//  AccountInfoViewController.swift
//  TMDB App
//
//  Created by KIm on 01.05.2023.
//

import UIKit
import Alamofire


class AccountInfoViewController: UIViewController{
    
    
    //MARK: Variables
  //  var userName: String?
  //  var sessionID: String?
    var tableViewNames = ["Movie Watch List", "TV Shows Watchlist", "Rated TV Movies", "Rated TV Shows", "Rated TV Episodes"]
    
    //MARK: UI
    
    @IBOutlet weak var labelOfUsername: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(" \n \n \n")
        
        if let accountInfo = NetworkManager.shared.accountInfo {

            
            labelOfUsername.text = accountInfo.username
          
            
        }

        
        
 
        
        
        
        
    }
    
    
}



extension AccountInfoViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView .dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = tableViewNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //https://api.themoviedb.org/3/account/17215644/favorite/movies?api_key=15ec7b54d43e199ced41a6e461173cee&session_id=23edc26504d55630d7caca87d3e35f4f58e236f0&language=en-US&sort_by=created_at.asc&page=1
        print("account = \(NetworkManager.shared.accountInfo?.id)")
        NetworkManager.shared.getFavoriteMovies(){
            success in
            
            
        }
        
        //creating request
        //seguei 
    }
}
