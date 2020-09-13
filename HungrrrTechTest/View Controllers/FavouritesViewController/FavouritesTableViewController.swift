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
    
    let db = DBUtility.sharedInstance
    var favouritePlayers: Results<FavouritePlayer>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setUpTableview()
        getFavouritePlayerData()
    }
    
    func setupUI() {
        self.title = "Favourite Players"
    }
    
    func getFavouritePlayerData() {
        self.favouritePlayers = db.getAllFavouritePlayers()
    }
    
    func setUpTableview() {
        tableView.register(UINib(nibName: TableViewCellIdentifier.playerCell, bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifier.playerCell)
        tableView.register(UINib(nibName: TableViewCellIdentifier.genericCell, bundle: nil),
        forCellReuseIdentifier: TableViewCellIdentifier.genericCell)
        //TODO: Use heightForRowAtIndexPath to make UI more consistent in both TVs.
        tableView.rowHeight = 75
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let players = favouritePlayers else { return UITableViewCell() }
        
        if players.isEmpty {
            guard let genericCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.genericCell,
                                                                  for: indexPath) as? GenericTableViewCell else { return UITableViewCell() }
            genericCell.centerLabel.text = "No Favourites!"
            return genericCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.playerCell,
                                                           for: indexPath) as? PlayerTableViewCell else { return UITableViewCell() }
            let player = players[indexPath.row]
            cell.playerNameLabel.text = "\(player.playerFirstName) \(player.playerSecondName)"
            cell.ageLabel.text = "\(player.playerAge)"
            cell.clubLabel.text = "\(player.playerClub)"
            cell.showHeartImage()
            return cell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let players = favouritePlayers else { return 1 }
        return players.isEmpty ? 1 : players.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let players = self.favouritePlayers else { return }
        
        if !players.isEmpty{
            let player = players[indexPath.row]
            db.deleteFavouritePlayer(playerID: player.playerID)
            DispatchQueue.main.async {
                if players.count >= 1 {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.reloadData()
                } else {
                    //TODO: Must be a way that this can smoothly transition into the generic cell.
                    tableView.reloadData()
                }
            }
        }
    }
}
