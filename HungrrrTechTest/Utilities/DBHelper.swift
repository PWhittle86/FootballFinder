//
//  DBHelper.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 13/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation

import RealmSwift

class DBHelper {
    
    static let sharedInstance = DBHelper()
    let db : Realm
    var configuration = Realm.Configuration()
    
    private init() {
        self.configuration.fileURL = configuration.fileURL!.deletingLastPathComponent().appendingPathComponent("FavouritePlayers.Realm")
        do {
            self.db = try! Realm(configuration: self.configuration)
        }
    }
    
    func add(object: Object) {
//        let backgroundRealm = try! Realm(configuration: self.configuration)
            do { try db.write({
            db.add(object)
            })
        } catch {
            print("Unable to add object to realm. Error: \(error)")
        }
    }
    
}
