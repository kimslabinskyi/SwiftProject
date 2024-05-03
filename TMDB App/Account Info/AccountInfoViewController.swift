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
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? WatchlistViewController{
            let reversedDataSource = Array(watchlistMoviesDataSource.reversed())
                //destinationVC.watchlistMoviesDataSource = reversedDataSource
        }
    }
    
    
    @IBAction func watchlistButton(_ sender: Any) {
        
        performSegue(withIdentifier: "WatchlistSegue", sender: nil)
    }
    
    
    
}



