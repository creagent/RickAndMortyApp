//
//  EndPoint.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 27.03.2021.
//

import Foundation

protocol EndPoint {
    var queryParameters: [String: Any?] { get }
    var httpMethod: HTTPMethod { get }
    var APImethod: String { get }
    var urlComponents: URLComponents { get }
    var queryItems: [URLQueryItem] { get }
    var path: String { get }
    var baseUrl: String { get }
    var subPath: String { get }
}

extension EndPoint {
    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrl
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents
    }
    
    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []
        queryParameters.forEach {
            if $0.value != nil {
                items.append(URLQueryItem(name: $0.key, value: String(describing: $0.value!)))
            }
        }
        return items
    }
    
    var path: String {
        "/\(subPath)/\(APImethod)"
    }
    
    var subPath: String {
        "api"
    }
    
    var baseUrl: String {
        return "rickandmortyapi.com"
    }
}
