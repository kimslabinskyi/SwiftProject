//
//  AccountInfoViewController.swift
//  TMDB App
//
//  Created by KIm on 01.05.2023.
//

import UIKit
import Alamofire


class AccountInfoViewController: UIViewController{
    
    @IBOutlet weak var labelOfUsername: UILabel!
    var watchlistMoviesDataSource: [WatchlistMovie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(" \n \n \n")
        
        let accountInfo: AccountInfo?
        var accountId: Int = 0

        if let accountInfo = NetworkManager.shared.accountInfo {
            accountId = accountInfo.id
            labelOfUsername.text = accountInfo.username
            print(accountInfo.id)
        }
        
            
        NetworkManager.shared.getWatchlistMovies(accountId: accountId){
            [weak self] watchlistMoviesResponse in
            guard let self = self else { return }
            
            if let movies = watchlistMoviesResponse {
                self.watchlistMoviesDataSource = movies.results
            } else {
                print("Failed to fetch genres")
            }
        }
    
        
        
    }
    
    
    @IBAction func watchlistButton(_ sender: Any) {
        
        performSegue(withIdentifier: "WatchlistSegue", sender: nil)
    }
    
    
    
}



