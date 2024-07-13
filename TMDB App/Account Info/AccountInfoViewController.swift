//
//  AccountInfoViewController.swift
//  TMDB App
//
//  Created by Kim on 01.05.2023.
//

import UIKit
import Alamofire


class AccountInfoViewController: UIViewController{
    
    @IBOutlet weak var labelOfUsername: UILabel!
    var watchlistMoviesDataSource: [WatchlistMovie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(" \n \n \n")
        
            
        WatchlistData.shared.getData()
        RatedMoviesData.shared.getData(page: 1) 
        
    }
    override func viewDidAppear(_ animated: Bool) {
        RatedMoviesData.shared.getData(page: 1)
    }
    
    @IBAction func watchlistButton(_ sender: Any) {
        
        performSegue(withIdentifier: "WatchlistSegue", sender: nil)
    }
    
    
    
}



