//
//  TeamSearchViewController.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import UIKit

public enum AvailableTableviewData {
    case PlayersAndTeams
    case OnlyPlayers
    case OnlyTeams
    case NoData
}

class TeamSearchViewController: UIViewController {
    
    var coordinator: MainCoordinator?
    let networkUtility = NetworkUtility()
    let db = DBHelper.sharedInstance
    
    var players: [Player] = []
    var teams: [Team] = []
    var favouritePlayers: [FavouritePlayer] = []
    
    var previousSearchString: String?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        setupSearchbutton()
        setupUI()
    }
    
    //MARK: Setup Functions
    
    func setupUI() {
        self.title = "Football Finder"
        
        let favouritesButton = UIBarButtonItem(title: "Favourites", style: .plain, target: self, action: #selector(favouritesButtonTapped))
        self.navigationItem.rightBarButtonItem = favouritesButton
    }
    
    func setupSearchbutton() {
        self.searchButton.isEnabled = false
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TableViewCellIdentifier.playerCell, bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifier.playerCell)
        tableView.register(UINib(nibName: TableViewCellIdentifier.teamCell, bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifier.teamCell)
        tableView.register(UINib(nibName: TableViewCellIdentifier.noResultsCell, bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifier.noResultsCell)
        tableView.register(UINib(nibName: TableViewCellIdentifier.moreCell, bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifier.moreCell)
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    //MARK: Data Functions
    
    /*
     This function is used to check what data, if any, is currently available for the tableview to use following a search to the player/team API.
     It is used extensively throughout the tableview's delegate functions.
     
     There are 4 possible scenarios being checked:
     1. Teams + Players
     2. Only Players
     3. Only Teams
     4. No Players or Teams
     
     Based on the current capabilities of the API and the scope of this exercise, this covers all of the different types of
     data configurations that need to be considered by the tableview.
     */
    func availableDataCheck() -> AvailableTableviewData {
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
        //No Players or Teams
        return AvailableTableviewData.NoData
    }
    
    func fetchPlayerAndTeamData(searchString: String,
                                isFirstSearch: Bool,
                                searchType: SearchParameter?,
                                offset: Int?) {
        let completionHandler: (PlayerTeamRootObject) -> Void = { [weak self] (footballData) in
            
            if let players = footballData.result.players {
                for player in players {
                    self?.players.append(player)
                }
            }
            
            if let teams = footballData.result.teams {
                for team in teams {
                    self?.teams.append(team)
                }
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        networkUtility.executeSearch(searchString: searchString,
                                     isFirstSearch: isFirstSearch,
                                     searchType: searchType,
                                     offset: offset,
                                     completionHandler: completionHandler)
    }
    
    @objc func favouritesButtonTapped() {
        self.coordinator?.navigateToFavouritesController()
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        //TODO: Temp solution to double search issue, but architectural change of firstSearchCheck might be better.
        //Disabling the search button after a search so that user has to change the search string to search for new data.
        self.searchButton.isEnabled = false
        executeSearch(searchParameter: nil, offset: nil)
    }
    
    func executeSearch(searchParameter: SearchParameter?, offset: Int?) {
        //TODO: Check this is working as intended.
        guard let searchString = self.searchBar.text else { return }
        let isNewSearch = self.firstSearchCheck(searchString: searchString)

        if isNewSearch {
            self.clearTableDataPriorToNewSearch(searchString: searchString)
            self.fetchPlayerAndTeamData(searchString: searchString,
                                       isFirstSearch: isNewSearch,
                                       searchType: nil,
                                       offset: nil)
        } else {
            self.fetchPlayerAndTeamData(searchString: searchString,
                                        isFirstSearch: false,
                                        searchType: searchParameter,
                                        offset: offset)
        }
        

    }
    
    //TODO: This won't work - will cause issues if the user updates the searchstring and then taps on more. Fix.
    //Check if user is searching for the first time by comparing the string he is searching for to the last string he searched for.
    func firstSearchCheck(searchString: String) -> Bool {
        return searchString == previousSearchString ? false : true
    }
    
    //If the user is searching for new data, clear everything that we currently hold in the data arrays.
    func clearTableDataPriorToNewSearch(searchString: String) {
        //TODO: Consider moving this logic to the completion handler, so that data is only deleted once we know new data has been successfully received?
        if self.previousSearchString ?? "" != searchString {
            players.removeAll()
            teams.removeAll()
        }
        self.previousSearchString = searchString
    }
    
    func isFavouritePlayer(playerID: String) -> Bool {
        return !db.findFavouritePlayer(playerID: playerID).isEmpty
    }
    
}

extension TeamSearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableviewSectionCount()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let playerHeading = TableViewSectionHeader.players
        let teamHeading = TableViewSectionHeader.teams
        
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
        var playerCount = players.count
        var teamCount = teams.count
        
        //If not 0 and multiple of 10 there may be more data available to download from the API. Add 1 to the team/player count so there is room for the MoreCell.
        //TODO: Figure out how to handle a final batch of data which brings the player count to a multiple of 10.
        if (playerCount != 0) && (playerCount % 10 == 0){
            playerCount += 1
        }
        
        if (teamCount != 0) && (teamCount % 10 == 0){
            teamCount += 1
        }
        
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
            //Return a single row in the event that no data is available, for the No Data cell.
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
            if let noResultsCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.noResultsCell,
                                                                 for: indexPath) as? NoResultsTableViewCell {
                return noResultsCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        if cell.isKind(of: PlayerTableViewCell.self) {
            guard let playerCell = cell as? PlayerTableViewCell else {  return }
                        
            let player = players[indexPath.row]
            
            if isFavouritePlayer(playerID: player.playerID) {
                playerCell.setFavouritePlayerStatus(bool: false)
                playerCell.hideHeartImage()
                db.deleteFavouritePlayer(playerID: player.playerID)
            } else {
                playerCell.setFavouritePlayerStatus(bool: true)
                playerCell.showHeartImage()
                
                let favouritePlayer = FavouritePlayer()
                
                favouritePlayer.playerID = player.playerID
                favouritePlayer.playerFirstName = player.playerFirstName
                favouritePlayer.playerSecondName = player.playerSecondName
                favouritePlayer.playerNationality = player.playerNationality
                favouritePlayer.playerAge = player.playerAge
                favouritePlayer.playerClub = player.playerClub
                
                db.addFavouritePlayer(player: favouritePlayer)
            }
        }
        
        if cell.isKind(of: MoreTableViewCell.self) {
            switch availableDataCheck() {
            case .PlayersAndTeams:
                if indexPath.section == 0 {
                    //Further search for players
                    self.executeSearch(searchParameter: SearchParameter.players, offset: self.players.count)
                    return
                } else {
                    self.executeSearch(searchParameter: SearchParameter.teams, offset: self.teams.count)
                    //Further search for teams
                    return
                }
            case .OnlyPlayers:
                //Further search for players
                self.executeSearch(searchParameter: SearchParameter.players, offset: self.players.count)
                return
            case .OnlyTeams:
                //further search for teams
                self.executeSearch(searchParameter: SearchParameter.teams, offset: self.teams.count)
                return
            case .NoData:
                return
            }
        }
    }
    
    func tableviewSectionCount() -> Int {
        switch  availableDataCheck() {
        case .PlayersAndTeams:
            return 2
        default:
            return 1
        }
    }
    
    func getPlayerCell(tableView: UITableView,
                       indexPath: IndexPath) -> UITableViewCell {
        
        //TODO: Placeholder - make this more robust.
        if (indexPath.row + 1) > self.players.count {
            if let moreCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.moreCell,
                                                            for: indexPath) as? MoreTableViewCell {
                moreCell.setLabelText(tableViewSectionType: TableViewSectionHeader.players)
                return moreCell
            }
        }
        
        if let playerCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.playerCell,
                                                          for: indexPath) as? PlayerTableViewCell {
            if self.players.isEmpty {
                return playerCell
            }
            
            let player = self.players[indexPath.row]
            
            if isFavouritePlayer(playerID: player.playerID) {
                playerCell.setFavouritePlayerStatus(bool: true)
                playerCell.showHeartImage()
            }
            
            playerCell.playerNameLabel.text = "\(player.playerFirstName) \(player.playerSecondName)"
            playerCell.ageLabel.text = player.playerAge
            playerCell.clubLabel.text = player.playerClub
            
            return playerCell
        }
        return PlayerTableViewCell()
    }
    
    func getTeamCell(tableView: UITableView,
                     indexPath: IndexPath) -> UITableViewCell {
        
        //TODO: Placeholder. Make this more robust.
        if (indexPath.row + 1) > self.teams.count {
            if let moreCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.moreCell,
                                                            for: indexPath) as? MoreTableViewCell {
                moreCell.setLabelText(tableViewSectionType: TableViewSectionHeader.teams)
                return moreCell
            }
        }
        
        if let teamCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.teamCell,
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

//Perhaps put these into their own variables to tidy the file up a bit?
extension TeamSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*A single character isn't enough info for a useful search to be completed. As such, I've limited access to the search button until the user has entered at least 2 characters. Additionally, since we want users to search for more players/teams using the More cell, rather than the search button, the search cell is disabled if the search text is the same as the last string they searched for.*/
        //TODO: Review as part of previousSearchString refactoring (if necessary).
        if (searchText.count >= 2) && (searchText != previousSearchString) {
            self.searchButton.isEnabled = true
        } else {
            self.searchButton.isEnabled = false
        }
    }
}
