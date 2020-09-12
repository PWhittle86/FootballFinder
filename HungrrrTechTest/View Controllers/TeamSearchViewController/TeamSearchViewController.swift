//
//  TeamSearchViewController.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import UIKit

//MARK: Tableview Section Indexes - these will probably need to be removed.
public enum tableViewSections: Int {
    case Players = 0
    case Teams = 1
}

class TeamSearchViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    let networkUtility = NetworkUtility()
    
    var players: [Player] = []
    var teams: [Team] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViews()
        setupSearchBar()
        setupUI()
    }
    
    func fetchPlayerAndTeamData(searchString: String) {
        let completionHandler: (FootballAPIJSON) -> Void = { [weak self] (footballData) in
            
            for player in footballData.result.players {
                //TODO: going to need some logic in here so that duplicate players aren't added to the array.
                self?.players.append(player)
            }
            
            for team in footballData.result.teams {
                self?.teams.append(team)
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        networkUtility.basicPlayerTeamSearch(searchString: searchString, completion: completionHandler)
    }
    
    func setupUI() {
        self.searchButton.isEnabled = false
    }
    
    func setupTableViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TableViewCellIdentifiers.playerCell, bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifiers.playerCell)
        tableView.register(UINib(nibName: TableViewCellIdentifiers.teamCell, bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifiers.teamCell)
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if let searchString = self.searchBar.text {
            fetchPlayerAndTeamData(searchString: searchString)
        }
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
        switch section {
        case tableViewSections.Players.rawValue:
            return players.count
        case tableViewSections.Teams.rawValue:
            return teams.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case tableViewSections.Players.rawValue:
            if let playerCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.playerCell,
                                                              for: indexPath) as? PlayerTableViewCell {
                if self.players.isEmpty {
                    return playerCell
                }
                
                let player = self.players[indexPath.row]
                playerCell.playerNameLabel.text = "\(player.playerFirstName) \(player.playerSecondName)"
                playerCell.ageLabel.text = player.playerAge
                playerCell.clubLabel.text = player.playerClub
                return playerCell
            }
            
        case tableViewSections.Teams.rawValue:
            if let teamCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.teamCell,
                                                            for: indexPath) as? TeamTableViewCell {
                if self.teams.isEmpty {
                    return teamCell
                }
                
                let team = self.teams[indexPath.row]
                teamCell.cityLabel.text = team.teamCity
                teamCell.stadiumLabel.text = team.teamStadium
                teamCell.teamNameLabel.text = team.teamName
                return teamCell
            }
            
        default:
            print("Unable to dequeue player/teams tableview cell.")
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

extension TeamSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*A single character isn't enough info for a useful search to be completed.
         As such, I've limited access to the search button until the user has entered at least 2 characters. */
        if searchText.count >= 2 {
            self.searchButton.isEnabled = true
        } else {
            self.searchButton.isEnabled = false
        }
    }
}
