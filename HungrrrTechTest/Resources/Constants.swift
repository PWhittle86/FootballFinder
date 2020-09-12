//
//  Constants.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 12/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation

//MARK: Error Constants
public enum DownloadError: String, Error {
    case badData = "Data is invalid"
    case redirectionError  = "Server Redirection error"
    case clientError = "Client not responding as expected"
    case serverError = "Server Error"
    case invalidRequest = "Request is invalid"
    case unknownError = "Unknown Error"
}

//MARK: TableViewCell Identifiers
struct TableViewCellIdentifiers {
    static let playerCell = "PlayerTableViewCell"
    static let teamCell = "TeamTableViewCell"
    static let noResultsCell = "NoResultsTableViewCell"
}

//MARK: Tableview Section Indexes - these will probably need to be removed.
struct TableViewSectionHeaders {
    static let players = "Players"
    static let teams = "Teams"
}

public enum AvailableTableviewData {
    case PlayersAndTeams
    case OnlyPlayers
    case OnlyTeams
    case NoData
}
