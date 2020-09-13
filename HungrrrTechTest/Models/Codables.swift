//
//  Codables.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation

struct FootballAPIRootDataObject: Codable {
    let result: SuccessfulResult
}

struct SuccessfulResult: Codable {
    let players: [Player]?
    let teams: [Team]?
    let status: Bool
    let message: String
    let request_order: Int
    let searchType, searchString, minVer, serverAlert: String
}

struct Player: Codable {
    let id, firstName, secondName, nationality: String
    let age, club: String
    
    enum CodingKeys: String, CodingKey {
        case id = "playerID"
        case firstName = "playerFirstName"
        case secondName = "playerSecondName"
        case nationality = "playerNationality"
        case age = "playerAge"
        case club = "playerClub"
    }
}

struct Team: Codable {
    let id, name, stadium, nation: String
    let nationality, city: String
    
    enum CodingKeys: String, CodingKey {
        case id = "teamID"
        case name = "teamName"
        case stadium = "teamStadium"
        case nation = "isNation"
        case nationality = "teamNationality"
        case city = "teamCity"
    }
    
}
