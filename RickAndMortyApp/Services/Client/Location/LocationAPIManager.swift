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
