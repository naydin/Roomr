//
//  RoomrApp.swift
//  Roomr
//
//  Created by Necati Aydın on 10/11/2021.
//

import SwiftUI

@main
struct RoomrApp: App {
    var body: some Scene {
        WindowGroup {
            roomsView()
        }
    }
    
    func roomsView() -> RoomsView {
        let viewModel = RoomsViewModel()
        viewModel.rooms = [
            Room(imageURL: URL(string:  "https://images.unsplash.com/photo-1540760029765-138c8f6d2eac?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=634&q=80")!,
                 name: "Ljerka",
                 spots: 43,
                 isBooked: false)
        ]
        return RoomsView(viewModel: viewModel)
    }
}
