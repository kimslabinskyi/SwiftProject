//
//  RegionViewController.swift
//  TMDB App
//
//  Created by KIm on 08.09.2023.
//

import UIKit

class RegionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getAllRegions(){ regions in
            if let allRegions = regions {

                for region in allRegions {
                    print("Region ISO Code: \(region.iso_3166_1), English Name: \(region.english_name)")
                }
                print(regions?.count)
            } else {
 
                print("Failed to fetch regions")
            }
        }
        
//        regionKeys = Array(regions.keys)
//        regionValues = Array(regions.values)
//
//
//        lazy var regionKeys: [String] = {
//                return Array(self.regions.keys)
//            }()
    }
    
//    let regionsNames: [String: String] = ["Ukraine": "🇺🇦", "USA": "🇺🇸","Britain": "🇬🇧","Italian": "🇮🇹", "Portugal": "🇵🇹", "Spain": "🇪🇸", "German": "🇩🇪", "France": "🇫🇷", "Japan": "🇯🇵", "Saudi Arabia": "🇸🇦", "Georgia": "🇬🇪" ]
//
    
    let regionsNames: [String] = ["USA", "Ukraine","Italian", "Portugal", "Spain", "German", "France", "Japan", "Saudi Arabia", "Georgia" ]
    let regionsFlags: [String] = [ "🇺🇸", "🇺🇦", "🇮🇹", "🇵🇹", "🇪🇸", "🇩🇪",  "🇫🇷", "🇯🇵", "🇸🇦", "🇬🇪" ]



}

extension RegionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        regionsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "regionCell", for: indexPath) as! RegionsTableViewCell
        cell.regionLabel.text = regionsNames[indexPath.row]
        cell.flagLabel.text = regionsFlags[indexPath.row]
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        return cell 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            SelectedRegion.shared.region = "en-US"
            print(SelectedRegion.shared.region)
        } else if indexPath.row == 1{
            SelectedRegion.shared.region = "uk-UA"
            print(SelectedRegion.shared.region)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }

 
    
}
