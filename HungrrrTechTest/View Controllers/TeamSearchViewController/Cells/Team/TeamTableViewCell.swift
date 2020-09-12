//
//  PlayerTableViewCell.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var cityHeadingLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stadiumHeadingLabel: UILabel!
    @IBOutlet weak var stadiumLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
