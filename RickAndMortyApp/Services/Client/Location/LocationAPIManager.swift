//
//  LocationAPIManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 24.03.2021.
//

import Foundation

enum LocationEndPoint: EndPoint {
    case location(page: Int? = nil)
    
    var queryParameters: [String : Any?] {
        let parameters: [String : Any]
        switch self {
        case .location(let page):
            parameters = [
                "page": page as Any
            ]
        }
        return parameters
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .location:
            return .get
        }
    }
    
    var APImethod: String {
        return "location"
    }
}

// Struct contains methods to request location information
struct LocationAPIManager {
    // MARK: - Public
//    func getLocationByURL(url: String, completion: @escaping (Result<LocationModel, Error>) -> Void) {
//        NetworkManager.requestByUrl(url: url) {
//            switch $0 {
//            case .success(let data):
//                if let location: LocationModel = JSONHandler.decodeJSONData(data: data) {
//                    completion(.success(location))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
}
