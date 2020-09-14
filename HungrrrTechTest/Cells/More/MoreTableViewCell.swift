//
//  MoreTableViewCell.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 12/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import UIKit

class MoreTableViewCell: UITableViewCell {

    @IBOutlet weak var moreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLabelText(tableViewSectionType: String) {
        switch tableViewSectionType {
        case "Players":
            moreLabel.text = "More Players..."
        case "Teams":
            moreLabel.text = "More Teams..."
        default:
            moreLabel.text = "More..."
        }
    }
    
}
