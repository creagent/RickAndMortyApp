//
//  Episode.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 14.02.2021.
//

import Foundation

// Struct for decoding json representation of character's first appearance episode
struct EpisodeModel: Codable, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case episode
        case characters
        case url
        case created
        case airDate = "air_date"
    }
}
