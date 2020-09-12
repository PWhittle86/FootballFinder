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
}

//MARK: Tableview Section Indexes
public enum tableViewSections: Int {
    case Players = 0
    case Teams = 1
}
