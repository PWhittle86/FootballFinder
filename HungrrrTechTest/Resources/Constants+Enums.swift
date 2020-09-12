//
//  Constants+Enums.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 12/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation

//Strings, particularly those that are used in more than one place, have been stored here as static properties in order to ease any changes which need to be made in future. Enums used throughout the project are also stored here.

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
struct TableViewCellIdentifier {
    static let playerCell = "PlayerTableViewCell"
    static let teamCell = "TeamTableViewCell"
    static let noResultsCell = "NoResultsTableViewCell"
    static let moreCell = "MoreTableViewCell"
}

//MARK: Tableview Section Indexes
struct TableViewSectionHeader {
    static let players = "Players"
    static let teams = "Teams"
}

//MARK: NetworkUtility Constants {
struct NetworkUtilityConstant {
    static let apiString = "http://trials.mtcmobile.co.uk/api/football/1.0/search"
}

//MARK: Search parameter types for API requests
public enum SearchParameter {
    case players
    case teams
}
