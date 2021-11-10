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
        do {
            try database.write {
                let objects: [RoomObject] = rooms.compactMap { [weak self] room in
                    guard let self = self else { return nil }
                    
                    let object: RoomObject
                    if let roomObject = self.getRoom(name: room.name) {
                        object = roomObject
                    } else {
                        object = RoomObject()
                        object.name = room.name
                    }
                    
                    object.spots = room.spots
                    object.imageURL = room.imageURL.absoluteString
                    return object
                }
                database.add(objects, update: .modified)//TODO: check if this will override is booked
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
                    return Room(
                        imageURL: url,
                        name: roomObject.name,
                        spots: roomObject.spots,
                        isBooked: roomObject.isBooked ?? false
                    )
                }
            }
            .eraseToAnyPublisher()
        
        return roomsPublisher
    }
    
    @MainActor
    func book(roomName: String) {
        guard let room = getRoom(name: roomName) else {
            assert(false, "No room with name \(roomName)")
            return
        }

        do {
            try database.write {
                room.isBooked = true
                database.add(room, update: .modified)
            }
        } catch let error {
            print("Error while trying to book the room \(roomName): \(error)")
        }
    }
    
    private func getRoom(name: String) -> RoomObject? {
        let predicate = NSPredicate(format: "name = %@", name)
        return database.objects(RoomObject.self).filter(predicate).first
    }
}
