//
//  Codables.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation

//TODO: Make these comments appear as an XCode description
struct PlayerTeamRootObject: Codable {
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
    //TODO: Use coding keys to turn these into neater values. See table view controller for details.
    let playerID, playerFirstName, playerSecondName, playerNationality: String
    let playerAge, playerClub: String
}

struct Team: Codable {
    //TODO: Use coding keys to turn these into neater values. See table view controller for details.
    let teamID, teamName, teamStadium: String, isNation: String
    let teamNationality, teamCity: String
}
