//
//  EndPoint.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 27.03.2021.
//

import Foundation

protocol EndPoint {
    var queryParameters: [String: String] { get }
    var httpMethod: String { get }
    var APImethod: String { get }
}
