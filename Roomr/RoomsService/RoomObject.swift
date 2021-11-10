//
//  RoomObject.swift
//  Roomr
//
//  Created by Necati Aydın on 10/11/2021.
//

import Foundation
import RealmSwift

class RoomObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var name: String = ""
    @Persisted var spots: Int = 0
    @Persisted var imageURL: String = ""
    @Persisted var isBooked: Bool = false
}
