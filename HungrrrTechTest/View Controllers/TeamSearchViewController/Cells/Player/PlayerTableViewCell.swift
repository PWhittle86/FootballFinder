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
    
    private var favouritePlayer = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Hide heart image initially so that user can add
        self.selectionStyle = .none
        heartImage.alpha = 0
    }

    func setFavouritePlayerStatus(bool: Bool) {
        favouritePlayer = bool
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
}
