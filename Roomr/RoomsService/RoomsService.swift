//
//  RoomsService.swift
//  Roomr
//
//  Created by Necati Aydın on 10/11/2021.
//

import Foundation
import Combine

class RoomsService {
    private let database = RoomsDatabase()
    private let api = RoomsAPI()
    
    func start() async {
        let rooms = await api.getRooms()
        await database.save(rooms: rooms)
    }
    
    func book(roomName: String) {
        Task {
            await database.book(roomName: roomName)
        }
    }
    
    func roomsPublisher() -> AnyPublisher<[Room], Error> {
        database.roomsPublisher()
    }
}
