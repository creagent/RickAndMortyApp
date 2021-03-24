//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 18.02.2021.
//

import Foundation

// Struct for storing character list in file
struct CharacterListModel: Codable {
    let characters: [CharacterModel]
}

// Struct for character's data appropriate form interpretation
struct CharacterModel: Codable {
    let name: String
    let status: String
    let location: String
    let imageUrl: String
    var firstEpisode: String
    
    init(from data: CharacterData) {
        name = data.name
        status = data.status
        location = data.location.name
        imageUrl = data.image
        firstEpisode = data.episode[0]
    }
}

// Struct for decoding character's json representation
struct CharacterData: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterOriginModel
    let location: CharacterLocationModel
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

// Struct for representing character list response
struct CharacterInfoModel: Decodable {
    let info: Info
    let results: [CharacterData]
}

// Struct for decoding character's origin json info
struct CharacterOriginModel: Decodable {
    let name: String
    let url: String
}

// Struct for decoding character's location json info
struct CharacterLocationModel: Decodable {
    let name: String
    let url: String
}
