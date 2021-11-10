//
//  RoomsDatabase.swift
//  Roomr
//
//  Created by Necati Aydın on 10/11/2021.
//

import Foundation
import RealmSwift
import Combine

class RoomsDatabase {
    private let database = DatabaseManager.shared.realm
    
    @MainActor
    func save(rooms: [Room]) {
        let objects: [RoomObject] = rooms.map { room in
            let object = RoomObject()
            object.name = room.name
            object.spots = room.spots
            object.imageURL = room.imageURL.absoluteString
            return object
        }
        
        do {
            try database.write {
                database.add(objects, update: .all)//TODO: check if this will override is booked
            }
        } catch let error {
            print("Database error: \(error)")
        }
    }
    
    func roomsPublisher() -> AnyPublisher<[Room], Error> {
        let results = database.objects(RoomObject.self)
        
        let roomsPublisher: AnyPublisher<[Room], Error> = results.collectionPublisher
            .compactMap { results -> [Room] in
                let roomObjects = Array(results)
                
                return roomObjects.compactMap { roomObject in
                    guard let url = URL(string: roomObject.imageURL) else {
                        assert(false, "Invalid url")
                        return nil
                    }
                    return Room(imageURL: url, name: roomObject.name, spots: roomObject.spots, isBooked: roomObject.isBooked)
                }
            }
            .eraseToAnyPublisher()
        
        return roomsPublisher
    }
}
