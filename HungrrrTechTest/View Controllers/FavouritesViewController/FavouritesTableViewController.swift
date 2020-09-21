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
    
    //MARK: Setup Functions
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
    }
    
    //MARK: Tableview Delegate Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let players = favouritePlayers else { return 1 }
        //If players array is empty, return 1 row for the No Data cell.
        return players.isEmpty ? 1 : players.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let players = favouritePlayers else { return UITableViewCell() }
        
        if players.isEmpty {
            //Show generic cell with a label indicating no favourites saved on device.
            guard let genericCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.genericCell,
                                                                  for: indexPath) as? GenericTableViewCell else { return UITableViewCell() }
            genericCell.centerLabel.text = "No Favourites saved!"
            return genericCell
        } else {
            //Show player cell.
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.playerCell,
                                                           for: indexPath) as? PlayerTableViewCell else { return UITableViewCell() }
            let player = players[indexPath.row]
            cell.playerNameLabel.text = "\(player.firstName) \(player.secondName)"
            cell.ageLabel.text = "\(player.age)"
            cell.clubLabel.text = "\(player.club)"
            return cell
        }
    }

    //Standard iOS swipe tableview cell left to expose delete button and tap to delete.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let players = self.favouritePlayers else { return }
            if !players.isEmpty{
                let player = players[indexPath.row]
                db.deleteFavouritePlayer(playerID: player.ID)
                DispatchQueue.main.async {
                    if players.count >= 1 {
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } else {
                        tableView.reloadData()
                    }
                }
            }
        }
    }
}
