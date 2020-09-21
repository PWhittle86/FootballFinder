//
//  FavouritePlayer.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation
import RealmSwift

class FavouritePlayer: Object {

    @objc dynamic var ID = ""
    @objc dynamic var firstName = ""
    @objc dynamic var secondName = ""
    @objc dynamic var nationality = ""
    @objc dynamic var age = ""
    @objc dynamic var club = ""

    init(id: String, firstName: String, secondName: String, nationality: String, age: String, club: String) {
        self.ID = id
        self.firstName = firstName
        self.secondName = secondName
        self.nationality = nationality
        self.age = age
        self.club = club
    }
    
    required init() {
        //Do nothing.
    }
    
    override static func primaryKey() -> String? {
        return "ID"
    }
    
}
