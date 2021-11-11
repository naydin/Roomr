# Roomr

A meeting room booking application.

# Tech Stack
- SwiftUI used throughout the app. Also new iOS 15 libraries such as async/await and Task libraries are used. 
- Swift package manager is used for the dependency management. Only dependency used is Realm.
- For networking side, Apple's libraries are used. 

# Architecture
Classical MVVM is used for the application with an addition of service layer. The service layer for room list is reactive and the room list is always fetched from the database. The network is synced to the database. 

# Business Logic
- The list of rooms are shown by fethching from the endpoint provided. But they are stored in the database so they can be accessed offline. 
- The endpoint for booking a room is used but it is used as a dummy service. The boooking info is stored locally.


# TODO:
- Images should be cached.
- Unit tests.
- Padded rows.
- Readable padding for iPad.
- Show an alert when there is no internet connection. 
- Swiftlint.
