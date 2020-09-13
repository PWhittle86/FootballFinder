//
//  FavouritesTableViewController.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 13/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import UIKit

class FavouritesTableViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableview()
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
            return cell
        }
        return UITableViewCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
}
