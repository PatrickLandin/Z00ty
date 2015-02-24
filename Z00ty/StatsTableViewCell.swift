//
//  StatsTableViewCell.swift
//  Zooty
//
//  Created by GTPWTW on 2/23/15.
//  Copyright (c) 2015 pLandin. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {

    @IBOutlet var rankLabel: UILabel!
    
    @IBOutlet var itemImageView: UIImageView!
    
    @IBOutlet var totalVotesLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
