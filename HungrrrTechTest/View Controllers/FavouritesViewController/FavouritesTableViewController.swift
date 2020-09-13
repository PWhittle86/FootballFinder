//
//  FavouritesTableViewController.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 13/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import UIKit
import RealmSwift

class FavouritesTableViewController: UITableViewController {

    let db = DBHelper.sharedInstance
    var favouritePlayers: Results<FavouritePlayer>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableview()
        getFavouritePlayerData()
    }

    func getFavouritePlayerData() {
        self.favouritePlayers = db.getAllFavouritePlayers()
    }
    
    func setUpTableview() {
        tableView.register(UINib(nibName: TableViewCellIdentifier.playerCell, bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifier.playerCell)
        //TODO: Use heightForRowAtIndexPath to make UI more consistent in both TVs.
        tableView.rowHeight = 75
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.playerCell,
                                                    for: indexPath) as? PlayerTableViewCell {
            
            guard let players = favouritePlayers else {
                //TODO: Make this into a 'No Favourite Players!' cell.
                return UITableViewCell()
            }
        
            let player = players[indexPath.row]
            cell.playerNameLabel.text = "\(player.playerFirstName) \(player.playerSecondName)"
            cell.ageLabel.text = "\(player.playerAge)"
            cell.clubLabel.text = "\(player.playerClub)"
            
            return cell
        }
        return UITableViewCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //There is always only one section in this controller.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let players = favouritePlayers else { return 1 }
        
        if players.isEmpty {
            return 1
        } else {
            return players.count
        }
    }
    
}
