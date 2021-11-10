//
//  NetworkManager.swift
//  Roomr
//
//  Created by Necati Aydın on 10/11/2021.
//

import Foundation

protocol Request {
    associatedtype responseDTO: DTO
    
    var url: URL { get }
    var dto: responseDTO.Type { get }
}

protocol DTO: Decodable {
    
}


class NetworkManager {
    static var shared = NetworkManager()
    private var session = URLSession.shared
    
    private init() {}
    
    func make<R: Request>(request: R) async -> R.responseDTO? {
        let urlRequest = URLRequest(url: request.url)
        
        return await withCheckedContinuation { continuation in
            let task = session.dataTask(with: urlRequest) {(data, response, error) in
                guard let data1 = data else { return }
                
                do {
                    let dto = try JSONDecoder().decode(request.dto, from: data1)
                    continuation.resume(returning: dto)
                } catch let error {
                    print("\(error)")
                    continuation.resume(returning: nil)
                }
            }
            
            task.resume()
        }
    }
}
