//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 18.02.2021.
//

import Foundation

// Struct for decoding character's json representation
class CharacterModel: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterOriginModel
    let location: CharacterLocationModel
    let image: String
    let episodeUrls: [String]
    var episodes: [EpisodeModel]?
    let urlString: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case image
        case episodeUrls = "episode"
        case urlString = "url"
    }
}

// Struct for decoding character's origin json info
struct CharacterOriginModel: Codable {
    let name: String
    let url: String
}

// Struct for decoding character's location json info
struct CharacterLocationModel: Codable {
    let name: String
    let url: String
}
