//
//  RegionsTableViewCell.swift
//  TMDB App
//
//  Created by KIm on 11.09.2023.
//

import UIKit

class RegionsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    @IBOutlet weak var regionLabel: UILabel!
    
    @IBOutlet weak var flagLabel: UILabel!
    
    
    

}
