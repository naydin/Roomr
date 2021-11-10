//
//  RoomsService.swift
//  Roomr
//
//  Created by Necati Aydın on 10/11/2021.
//

import Foundation

struct RoomListRequest: Request {
    typealias responseDTO = RoomListResponseDTO
    var dto: RoomListResponseDTO.Type = RoomListResponseDTO.self
    let url = URL(string: "https://wetransfer.github.io/rooms.json")!
}

struct RoomDTO: DTO {
    let name: String
    let spots: Int
    let thumbnail: URL
}

struct RoomListResponseDTO: DTO {
    let rooms: [RoomDTO]
}

class RoomsService {
    func getRooms() async -> [Room] {
        let request = RoomListRequest()
        guard let roomDTOs = await NetworkManager.shared.make(request: request)?.rooms else {
            return []
        }
        
        return roomDTOs.map { roomDTO in
            Room(imageURL: roomDTO.thumbnail,
                 name: roomDTO.name,
                 spots: roomDTO.spots,
                 isBooked: false)//TODO: fix isbooked
        }
    }
}
