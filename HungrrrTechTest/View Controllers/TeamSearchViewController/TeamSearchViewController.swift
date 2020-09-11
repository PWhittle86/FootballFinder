//
//  TeamSearchViewController.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import UIKit

enum tableViewSections: Int {
    case Players = 0
    case Teams = 1
}

class TeamSearchViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    let networkUtility = NetworkUtility()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViews()
        networkUtility.basicPlayerTeamSearch(searchString: "barc")
    }
    
    func setupTableViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerTableViewCell")
        tableView.register(UINib(nibName: "TeamTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamTableViewCell")
    }
    
}

extension TeamSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //TODO: Make this dynamic.
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case tableViewSections.Players.rawValue:
            return "Players"
        case tableViewSections.Teams.rawValue:
            return "Teams"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: Make this dynamic.
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case tableViewSections.Players.rawValue:
            if let playerCell = tableView.dequeueReusableCell(withIdentifier: "PlayerTableViewCell", for: indexPath) as? PlayerTableViewCell {
                playerCell.ageLabel.text = "25"
                playerCell.clubLabel.text = "Real Madrid"
                playerCell.playerNameLabel.text = "David Football"
                return playerCell
            }
        case tableViewSections.Teams.rawValue:
            if let teamCell = tableView.dequeueReusableCell(withIdentifier: "TeamTableViewCell", for: indexPath) as? TeamTableViewCell {
                teamCell.cityLabel.text = "Edinburgh"
                teamCell.stadiumLabel.text = "Super Stadium"
                teamCell.teamNameLabel.text = "Hearts of Midlothian"
                return teamCell
            }
        default:
            print("Unable to dequeue player/teams tableview cell.")
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    
    
    
}
