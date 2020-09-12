//
//  TeamSearchViewController.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import UIKit

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
    
    /*
     This function is used to check what data, if any, is currently available for the tableview to use following a search to the player/team API.
     
     There are 4 possible scenarios:
     1. Teams + Players
     2. Only Players
     3. Only Teams
     4. No Players or Teams
     */
    
    func availableDataCheck() -> AvailableTableviewData {
        //TODO: Prime candidates for unit testing here.
        let appHasPlayerData = !self.players.isEmpty
        let appHasTeamData = !self.teams.isEmpty
        
        //Teams + Players
        if appHasPlayerData && appHasTeamData {
            return AvailableTableviewData.PlayersAndTeams
        }
        //Only Players
        if appHasPlayerData && !appHasTeamData {
            return AvailableTableviewData.OnlyPlayers
        }
        //Only Teams
        if !appHasPlayerData && appHasTeamData {
            return AvailableTableviewData.OnlyTeams
        }
        return AvailableTableviewData.NoData
    }
    
    func tableviewSectionCount() -> Int {
        var sectionCount = 0
        if !self.players.isEmpty {
            sectionCount += 1
        }
        if !self.teams.isEmpty {
            sectionCount += 1
        }
        return sectionCount
    }
    
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if let searchString = self.searchBar.text {
            fetchPlayerAndTeamData(searchString: searchString)
        }
    }
}

extension TeamSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableviewSectionCount()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let playerHeading = TableViewSectionHeaders.players
        let teamHeading = TableViewSectionHeaders.teams
        
        /* Check what data is available before determining what title to apply to the header of the section.*/
        
        switch availableDataCheck() {
        case .PlayersAndTeams:
            if section == 0 {
                return playerHeading
            } else {
                return teamHeading
            }
        case .OnlyPlayers:
            return playerHeading
        case .OnlyTeams:
            return teamHeading
        case .NoData:
            return ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let playerCount = players.count
        let teamCount = teams.count
        
        switch availableDataCheck() {
        case .PlayersAndTeams:
            if section == 0 {
                return playerCount
            } else {
                return teamCount
            }
        case .OnlyPlayers:
            return playerCount
        case .OnlyTeams:
            return teamCount
        case .NoData:
            //Return a single row in the event that no data is available
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch availableDataCheck() {
        case .PlayersAndTeams:
            if indexPath.section == 0 {
                return getPlayerCell(tableView: tableView,
                              indexPath: indexPath)
            } else {
                return getTeamCell(tableView: tableView,
                            indexPath: indexPath)
            }
        case .OnlyTeams:
            return getTeamCell(tableView: tableView,
                               indexPath: indexPath)
        case .OnlyPlayers:
            return getPlayerCell(tableView: tableView,
                                 indexPath: indexPath)
        case .NoData:
            if let noResultsCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.noResultsCell,
                                                                 for: indexPath) as? NoResultsTableViewCell {
                return noResultsCell
            }
        }
        
        
        
        
        
        return UITableViewCell()
    }
    
    func getPlayerCell(tableView: UITableView,
                          indexPath: IndexPath) -> PlayerTableViewCell {
        
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
        return PlayerTableViewCell()
    }
    
    func getTeamCell(tableView: UITableView,
                        indexPath: IndexPath) -> TeamTableViewCell {
        
        if let teamCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifiers.teamCell,
                                                        for: indexPath) as? TeamTableViewCell {
            if self.teams.isEmpty {
                return teamCell
            }
            
            let team = teams[indexPath.row]
            
            teamCell.cityLabel.text = team.teamCity
            teamCell.stadiumLabel.text = team.teamStadium
            teamCell.teamNameLabel.text = team.teamName
            return teamCell
        }
        return TeamTableViewCell()
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
