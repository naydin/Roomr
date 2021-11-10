//
//  RoomsView.swift
//  Roomr
//
//  Created by Necati Aydın on 10/11/2021.
//

import SwiftUI
import Combine

extension Color {
    static var app: Color {
        Color(red: 159.0/256.0, green: 0, blue: 134.0/256.0)
    }
}

struct BookButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.5) : Color.white)
            .background(Color.app)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct RoomsView: View {
    
    @ObservedObject var viewModel: RoomsViewModel
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                List {
                    ForEach(viewModel.rooms, id: \.self) { (room: Room)  in
                        RoomRow(
                            viewModel: viewModel,
                            imageURL: room.imageURL,
                            title: room.name,
                            spots: room.spots,
                            isBooked: room.isBooked,
                            width: proxy.size.width
                        )
                            .listRowInsets(EdgeInsets())
                    }
                    
                    .listRowSeparator(.hidden)
                }
                .listStyle(.grouped)
                //TODO: padded rows
            }
            .navigationTitle("Rooms")
        }
        .onAppear {
            viewModel.startSyncingData()
        }
        .onDisappear {
            viewModel.stopSyncingData()
        }
    }
}

private struct RoomRow: View {
    @ObservedObject var viewModel: RoomsViewModel
    
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
            } placeholder: {
                Rectangle().foregroundColor(.gray)//TODO: Placeholder
            }
            .frame(width: width, height: width * 9.0 / 16.0)
            .clipped()

            VStack {
                Spacer()
                
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.headline)
                        Text("\(isBooked ? (spots - 1) : spots) spots remaining")
                            .font(.subheadline)
                            .foregroundColor(.app)
                    }
                    
                    Spacer()
                    Button(isBooked ? "Booked" : "Book!") {
                        viewModel.book(roomName: title)
                    }
                    .buttonStyle(BookButtonStyle())
                    .disabled(isBooked)
                }
                .padding()
                .background(Material.ultraThin)
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
    private let service = RoomsService()
    private var cancellables = Set<AnyCancellable>()
    
    func startSyncingData() {
        Task {
            await service.start()
        }
        service.roomsPublisher()
            .receive(on: DispatchQueue.main)
            .sink { _ in} receiveValue: { [weak self] rooms in
                self?.rooms = rooms
            }
            .store(in: &cancellables)
    }
    
    func stopSyncingData() {
        cancellables = Set<AnyCancellable>()
    }
    
    func book(roomName: String) {
        service.book(roomName: roomName)
    }
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
//        return RoomRow(imageURL: URL(string:  "https://images.unsplash.com/photo-1571624436279-b272aff752b5?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1504&q=80")!,
//                       title: "Ljerka",
//                       spots: 43,
//                       isBooked: false, width: 375)
    }
}
