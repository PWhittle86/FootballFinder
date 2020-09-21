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
    let db = DBUtility.sharedInstance
    
    var players: [Player] = []
    var teams: [Team] = []
    var favouritePlayers: [FavouritePlayer] = []
    
    var hideNoResultsFoundLabel = true
    var previousSearchString: String?
    var timer: Timer?
    
    var spinnerView: UIView?
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkUtility.delegate = self
        setupTableView()
        setupSearchBar()
        setupButtons()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer?.invalidate()
        super.viewWillDisappear(animated)
    }
    
    //MARK: Setup Functions - Called As Part Of View Did Load
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TableViewCellIdentifier.playerCell, bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifier.playerCell)
        tableView.register(UINib(nibName: TableViewCellIdentifier.teamCell, bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifier.teamCell)
        tableView.register(UINib(nibName: TableViewCellIdentifier.genericCell, bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifier.genericCell)
        tableView.register(UINib(nibName: TableViewCellIdentifier.moreCell, bundle: nil),
                           forCellReuseIdentifier: TableViewCellIdentifier.moreCell)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    private func setupButtons() {
        let favouritesButton = UIBarButtonItem(title: "Favourites", style: .plain, target: self, action: #selector(favouritesButtonTapped))
        self.navigationItem.rightBarButtonItem = favouritesButton
    }
    
    private func setupUI() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: CustomFontNames.latoBold, size: 20) as Any]
        self.searchBar.searchTextField.font = UIFont(name: CustomFontNames.latoLight, size: 15)
        self.title = "Football Finder"
    }
    
    //MARK: Data Functions - Used For Interacting With the DB
    //Function to check which of the 4 possible data sets are available for the tableview to use.
    private func availableDataCheck() -> AvailableTableviewData {
        
        /* There are 4 possible scenarios where different data sets are available:
         1. Teams + Players
         2. Only Players
         3. Only Teams
         4. No Players or Teams */
        
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
    
    /* Function used to pass the correct data to the Network Utility. The searchString is always required, whilst the searchType and offset parameters are
    only used for follow up team/player searches. A completion handler is used to pass data back to the table view controller once the data
    has been returned from the back end. */
    private func fetchPlayerAndTeamData(searchString: String,
                                searchType: SearchParameter?,
                                offset: Int?) {
        let completionHandler: (FootballAPIRootDataObject, String) -> Void = { [weak self] (footballData, searchString) in
            
            //Remove old data from the team/player array if player searched for a new string
            self?.clearDataIfUserSearchedNewString(searchString: searchString)

            if let players = footballData.result.players {
                for player in players { self?.players.append(player) }
            }
            if let teams = footballData.result.teams {
                for team in teams { self?.teams.append(team) }
            }
            DispatchQueue.main.async {
                self?.removeSpinner()
                self?.tableView.reloadData()
            }
        }
        networkUtility.executeSearch(searchString: searchString,
                                     searchType: searchType,
                                     offset: offset,
                                     completionHandler: completionHandler)
    }
    
    //Quick check to determine if a specific player is in the DB based on their id (which is the designated primary key).
    private func isFavouritePlayer(playerID: String) -> Bool {
        return !db.findFavouritePlayer(playerID: playerID).isEmpty
    }
    
    //MARK: Search Management Functions - Used To Manage When/How User Searches For Data
    //Initial actions to be completed before starting a search.
    @objc func initialSearchActions() {
        if hideNoResultsFoundLabel {
            hideNoResultsFoundLabel = !hideNoResultsFoundLabel
        }
        guard let searchString = self.searchBar.text else { return }
        //Don't execute a search if less than 3 characters - data only really starts to become useful at that stage.
        if searchString.count > 2 {
            executeSearch(searchString:searchString, searchParameter: nil, offset: nil)
        }
        self.timer?.invalidate()
    }
    
    //Grab the searchString from the searchBar and check if the user is seeking additional results for the same string. If they are, additional params processed.
    func executeSearch(searchString: String, searchParameter: SearchParameter?, offset: Int?) {
        let isNewSearch = self.firstSearchCheck(searchString: searchString)

        if self.spinnerView == nil {
            displaySpinner()
        }
        
        if isNewSearch {
            self.fetchPlayerAndTeamData(searchString: searchString, searchType: nil, offset: nil)
        } else {
            self.fetchPlayerAndTeamData(searchString: searchString, searchType: searchParameter, offset: offset)
        }
    }
    
    //Check if user is searching for the first time by comparing the string he is searching for to the last string he searched for.
    private func firstSearchCheck(searchString: String) -> Bool {
        return searchString == previousSearchString ? false : true
    }
    
    //Clears everything that we currently hold in the data arrays if the user is searching for a fresh searchString.
    private func clearDataIfUserSearchedNewString(searchString: String) {
        if self.previousSearchString ?? "" != searchString {
            players.removeAll()
            teams.removeAll()
        }
        self.previousSearchString = searchString
    }
    
    //MARK: Navigation Functions
    @objc func favouritesButtonTapped() {
        self.coordinator?.navigateToFavouritesController()
    }
    
    //MARK: Spinner Functions
    //Spinner to be shown whilst searching for data
    func displaySpinner() {
        if self.spinnerView == nil {
            guard let window = self.view.window else { return }
            
            let spinnerView = UIView.init(frame: window.frame)
            spinnerView.center = window.center
            spinnerView.backgroundColor = .clear
            
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            blurView.frame = window.frame
            blurView.center = window.center
            blurView.alpha = 0.8
            spinnerView.insertSubview(blurView, at: 0)
            
            let activityIndicator = UIActivityIndicatorView.init(style: .medium)
            activityIndicator.startAnimating()
            activityIndicator.center = spinnerView.center
            
            self.spinnerView = spinnerView
            self.spinnerView?.addSubview(activityIndicator)
    }
        DispatchQueue.main.async {
            guard let tableView = self.tableView else { return }
            tableView.isScrollEnabled = false
            tableView.backgroundColor = .clear
            guard let loadview = self.spinnerView else { return }
            tableView.addSubview(loadview)
        }
    }
    
    //Removes spinner and nullifies the spinner view.
    func removeSpinner() {
        DispatchQueue.main.async {
            guard let tableview = self.tableView else { return }
            tableview.isScrollEnabled = true
            guard let loadview = self.spinnerView else { return }
            loadview.removeFromSuperview()
            self.spinnerView = nil
        }
    }
}

//MARK: Tableview Controller Data Source & Delegate
//These functions should be in their own dedicated class, but under the time pressure I wanted to make sure I could deliver a sound, working build.
//My first port of call, given another day to work on this, would be to reduce the size of this controller by carting this lot elsewhere!
extension TeamSearchViewController: UITableViewDataSource, UITableViewDelegate {

    //Populate rows with the appropriate cells, based on available data.
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
            return getTeamCell(tableView: tableView, indexPath: indexPath)
        case .OnlyPlayers:
            return getPlayerCell(tableView: tableView, indexPath: indexPath)
        case .NoData:
            guard let genericCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.genericCell,
                                                                  for: indexPath) as? GenericTableViewCell else { return UITableViewCell() }
                if hideNoResultsFoundLabel {
                    genericCell.centerLabel.isHidden = true
                } else {
                    genericCell.centerLabel.isHidden = false
                }
                genericCell.centerLabel.text = "No Results Found!"
                return genericCell
        }
    }
    
    //Allow user to mark players as favourites by selecting rows and to load more data by tapping 'More' cells.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        if cell.isKind(of: PlayerTableViewCell.self) {
            guard let playerCell = cell as? PlayerTableViewCell else { return }
                        
            let player = players[indexPath.row]
            
            if isFavouritePlayer(playerID: player.id) {
                playerCell.hideHeartImage()
                db.deleteFavouritePlayer(playerID: player.id)
            } else {
                playerCell.showHeartImage()
                
                let favouritePlayer = FavouritePlayer(id: player.id,
                                                      firstName: player.firstName,
                                                      secondName: player.secondName,
                                                      nationality: player.nationality,
                                                      age: player.age,
                                                      club: player.club)

                db.addFavouritePlayer(player: favouritePlayer)
            }
        }
        
        if cell.isKind(of: MoreTableViewCell.self) {
            guard let searchString = self.previousSearchString else { return }
            switch availableDataCheck() {
            case .PlayersAndTeams:
                if indexPath.section == 0 {
                    //Further search for players
                    self.executeSearch(searchString:searchString, searchParameter: SearchParameter.players, offset: self.players.count)
                    return
                } else {
                    //Further search for teams
                    self.executeSearch(searchString:searchString, searchParameter: SearchParameter.teams, offset: self.teams.count)
                    return
                }
            case .OnlyPlayers:
                //Further search for players
                self.executeSearch(searchString:searchString, searchParameter: SearchParameter.players, offset: self.players.count)
                return
            case .OnlyTeams:
                //Further search for teams
                self.executeSearch(searchString: searchString, searchParameter: SearchParameter.teams, offset: self.teams.count)
                return
            case .NoData:
                return
            }
        }
    }
    
    //Configure header section titles
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
        case .OnlyPlayers: return playerHeading
        case .OnlyTeams: return teamHeading
        case .NoData: return ""
        }
    }
    
    //Configure number of sections to display
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableviewSectionCount()
    }
    
    //Determine number of rows to be shown in tableview section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var playerCount = players.count
        var teamCount = teams.count
        
        /*If datacount != 0 and is a multiple of 10, there may be more data available to download from the API. Make room in the table for the 'More' cell,
          to enable additional data download.*/
        if (playerCount != 0) && (playerCount % 10 == 0){
            //Add 1 to the team/player count so there is room for the MoreCell.
            playerCount += 1
        }
        if (teamCount != 0) && (teamCount % 10 == 0){
            //Add 1 to the team/player count so there is room for the MoreCell.
            teamCount += 1
        }
        
        switch availableDataCheck() {
        case .PlayersAndTeams:
            if section == 0 {
                return playerCount
            } else {
                return teamCount
            }
        case .OnlyPlayers: return playerCount
        case .OnlyTeams: return teamCount
        case .NoData:
            //Return a single row in the event that no data is available, for the No Data cell.
            return 1
        }
    }
    
    //Return number of sections based on available data
    func tableviewSectionCount() -> Int {
        switch availableDataCheck() {
            case .PlayersAndTeams: return 2
            default: return 1
        }
    }
    
    //Configure height of tableview cells based on section & data available
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch availableDataCheck() {
        case .PlayersAndTeams:
            if indexPath.section == 0 {
                return 80
            } else {
                return 100
            }
        case .OnlyPlayers: return 80
        case .OnlyTeams: return 100
        case .NoData: return 80
        }
    }
    
    //Convenience function for returning the correct data for Player cells in cellForRowAtIndexPath.
    func getPlayerCell(tableView: UITableView,
                       indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.row + 1) > self.players.count {
            /*Check to see if we've reached the 'more' cell indexpath, which will always be 1 greater than the number of players. Adding 1 to the indexpath row
             is necessary to account for the entry at the 0 index. */
            guard let moreCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.moreCell,
                                                               for: indexPath) as? MoreTableViewCell else { return UITableViewCell() }
                moreCell.setLabelText(tableViewSectionType: TableViewSectionHeader.players)
                return moreCell
            }
        
        if let playerCell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.playerCell,
                                                          for: indexPath) as? PlayerTableViewCell {
            if self.players.isEmpty { return playerCell }
            
            let player = self.players[indexPath.row]
            
            if isFavouritePlayer(playerID: player.id) {
                playerCell.showHeartImage()
            } else {
                playerCell.hideHeartImage()
            }

            playerCell.populatePlayerData(name: "\(player.firstName) \(player.secondName)", age: player.age, club: player.club)
            return playerCell
        }
        return PlayerTableViewCell()
    }
    
    //Convenience function for returning the correct data for team cells in cellForRowAtIndexPath.
    func getTeamCell(tableView: UITableView,
                     indexPath: IndexPath) -> UITableViewCell {
        //Check to see if we've reached the 'more' cell indexpath, which will always be 1 greater than the number of players. Adding 1 to the indexpath row is necessary to account for the entry at the 0 index.
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
            teamCell.cityLabel.text = team.city
            teamCell.stadiumLabel.text = team.stadium
            teamCell.teamNameLabel.text = team.name
            
            return teamCell
        }
        return TeamTableViewCell()
    }
    
    
}

extension TeamSearchViewController: UISearchBarDelegate {
    //If searchbar text changes do a search after 0.4 seconds have passed.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(timeInterval: 0.4,
                                              target: self,
                                              selector: #selector(initialSearchActions),
                                              userInfo: nil,
                                              repeats: false)
        }
    }
}

extension TeamSearchViewController: FailedToCompleteNetworkRequest {
    //Delegate function from AlertUtility to dismiss spinner if anything stops data from being received.
    func didFailToProcessNetworkRequest() {
        if self.spinnerView != nil {
            self.removeSpinner()
        }
    }
}
