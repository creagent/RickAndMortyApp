//
//  LocationAPIManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 24.03.2021.
//

import Foundation

enum LocationEndPoint: EndPoint {
    case location(page: Int)
    
    var queryParameters: [String : String] {
        switch self {
        case .location(let page):
            return [
                "page": String(page)
            ]
        }
    }
    
    var httpMethod: String {
        switch self {
        case .location:
            return "get"
        }
    }
    
    var APImethod: String {
        return "location"
    }
    
    mutating func setPageNumber(pageNumber: Int) {
        switch self {
        case .location:
            self = .location(page: pageNumber)
        }
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
