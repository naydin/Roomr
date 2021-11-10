//
//  RoomsView.swift
//  Roomr
//
//  Created by Necati Aydın on 10/11/2021.
//

import SwiftUI
import Combine

struct RoomsView: View {
    
    @ObservedObject var viewModel: RoomsViewModel
    
    var body: some View {
        GeometryReader { proxy in
            List {
                ForEach(viewModel.rooms, id: \.self) { (room: Room)  in
                    RoomRow(
                        imageURL: room.imageURL,
                        title: room.name,
                        spots: room.spots,
                        isBooked: room.isBooked,
                        width: proxy.size.width
                    )
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: -8))
                .listRowSeparator(.hidden)
            }
            .listStyle(.grouped)
        }
    }
}

struct RoomRow: View {
    let imageURL: URL
    let title: String
    let spots: Int
    let isBooked: Bool
    let width: CGFloat
    
    var body: some View {
        ZStack {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
//                    .aspectRatio(16.0/9.0, contentMode: .fit)
                    
            } placeholder: {
                Rectangle()
            }
            .frame(width: width, height: width * 9.0 / 16.0)
            .clipped()

            VStack {
                Spacer()
                
                HStack {
                    Text(title)
                    Spacer()
                }
                .background(Material.thin)
                .frame(height: 60)
            }
        }
    }
}

struct Room: Hashable {
    let imageURL: URL
    let name: String
    let spots: Int
    let isBooked: Bool
}

class RoomsViewModel: ObservableObject {
    @Published var rooms: [Room] = []
}

struct RoomsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = RoomsViewModel()
        viewModel.rooms = [
            Room(imageURL: URL(string:  "https://images.unsplash.com/photo-1571624436279-b272aff752b5?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1504&q=80")!,
                 name: "Ljerka",
                 spots: 43,
                 isBooked: false),
            Room(imageURL: URL(string:  "https://images.unsplash.com/photo-1540760029765-138c8f6d2eac?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=634&q=80")!,
                 name: "Ljerka",
                 spots: 43,
                 isBooked: false)
        ]
        return RoomsView(viewModel: viewModel)
    }
}
