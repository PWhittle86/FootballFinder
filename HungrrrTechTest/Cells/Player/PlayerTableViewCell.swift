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
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var doubleLeftImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Hide heart image initially so that user can add
        self.selectionStyle = .none
        heartImage.alpha = 0
        doubleLeftImage.alpha = 0.3
        doubleLeftImage.isHidden = true
    }
    
    func populatePlayerData(name: String, age: String, club: String) {
        self.playerNameLabel.text = name
        self.ageLabel.text = age
        self.clubLabel.text = club
    }
    
    func showHeartImage() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
                self?.heartImage.alpha = 1
        })
    }
    
    func hideHeartImage() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
                self?.heartImage.alpha = 0
        })
    }
    
    func showDoubleLeftImage() {
        self.doubleLeftImage.isHidden = false
    }
}
