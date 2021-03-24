//
//  Location.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 18.02.2021.
//

import Foundation

// Struct for representing location list response
struct LocationInfoModel: Decodable {
    let info: Info
    let results: [LocationModel]
}

// Struct for decoding character location's json representation
struct LocationModel: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
