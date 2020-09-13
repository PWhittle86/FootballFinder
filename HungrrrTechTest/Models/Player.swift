//
//  Player.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation
import RealmSwift

class FavouritePlayer: Object {

    @objc dynamic var playerID = ""
    @objc dynamic var playerFirstName = ""
    @objc dynamic var playerSecondName = ""
    @objc dynamic var playerNationality = ""
    @objc dynamic var playerAge = ""
    @objc dynamic var playerClub = ""

    
    override static func primaryKey() -> String? {
        return "playerID"
    }
    
}
