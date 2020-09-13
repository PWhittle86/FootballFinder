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
    
    func addFavouritePlayer(player: FavouritePlayer) {
            do { try db.write({
            db.add(player)
            })
        } catch {
            print("Unable to add object to realm. Error: \(error)")
        }
    }
    
    func findFavouritePlayer(playerID: String) -> Results<FavouritePlayer> {
        return db.objects(FavouritePlayer.self).filter("playerID = '\(playerID)'")
    }
    
    func getAllFavouritePlayers() -> Results<FavouritePlayer> {
        return db.objects(FavouritePlayer.self)
    }
    
    func deleteFavouritePlayer(playerID: String) {
        let player = self.findFavouritePlayer(playerID: playerID)[0]
        do { try db.write({
            db.delete(player)
            })
        } catch {
            print("Unable to delete object from realm. Error: \(error)")
        }
    }
}
