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

    }
    
    let regionsNames: [String] = ["Ukraine", "USA","Britain","Italian", "Portugal", "Spain", "German", "France", "Japan", "Saudi Arabia", "Georgia" ]
    
    let regions = ["Ukraine": "UA", "Gernaja": "DE"]

}

extension RegionViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        regionsNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "regionCell", for: indexPath) as! RegionsTableViewCell
        cell.regionLabel.text = regionsNames[indexPath.row]
        cell.flagLabel.text = "🇦🇱"
        cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16) // Пример отступов 16 точек слева и справа

        return cell 
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Здесь устанавливайте высоту для каждой ячейки. Например, возвращаем 50 точек.
        return 50.0
    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        // Здесь можно установить высоту для заголовка секции (если он есть)
//        return 30.0
//    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        // Здесь можно установить высоту для подвала секции (если он есть)
        return 20.0
    }

    func tableView(_ tableView: UITableView, heightForSpacingBetweenSectionsIn section: Int) -> CGFloat {
        // Здесь можно установить отступ между секциями таблицы
        return 10.0
    }

    
    
    
}
