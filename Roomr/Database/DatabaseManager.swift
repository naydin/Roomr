//
//  DatabaseManager.swift
//  Roomr
//
//  Created by Necati Aydın on 10/11/2021.
//

import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    
    lazy var realm: Realm = {
        do {
            return try Realm()
        } catch let error {
            print("\(error)")
        }
        
        return try! Realm()
    }()
    
    private init() {}
}
