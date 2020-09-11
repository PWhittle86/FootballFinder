//
//  Codables.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation

struct PlayerTeamJson: Codable {
    let result: Result
}

struct Result: Codable {
    let players: [Player]
    let teams: [Team]
    let status: Bool
    let message: String
    let request_order: Int
    let searchType, searchString, minVer, serverAlert: String
}

struct Player: Codable {
    let playerID, playerFirstName, playerSecondName, playerNationality: String
    let playerAge, playerClub: String
}

struct Team: Codable {
    let teamID, teamName, teamStadium: String, isNation: String
    let teamNationality, teamCity: String
}
