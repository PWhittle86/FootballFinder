//
//  Codables.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation

//MARK: The 4 components of a basic search result
struct FootballAPIJSON: Codable {
    let result: Result
    
    init() {
        self.result = Result()
    }
}

struct Result: Codable {
    let players: [Player]
    let teams: [Team]
    let status: Bool
    let message: String
    let request_order: Int
    let searchType, searchString, minVer, serverAlert: String
    
    //Initialiser so that we can return an empty Result, if necessary.
    init() {
        self.players = []
        self.teams = []
        self.status = false
        self.message = ""
        self.request_order = 0
        self.searchType = ""
        self.searchString = ""
        self.minVer = ""
        self.serverAlert = ""
    }
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
