//
//  TeamTableViewCell.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var ageHeadingLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var clubHeadingLabel: UILabel!
    @IBOutlet weak var clubLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
