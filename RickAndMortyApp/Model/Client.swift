//
//  Client.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 18.02.2021.
//

import Foundation

struct Client {
    // MARK: - Public
    func character() -> CharacterAPIManager {
        let character = CharacterAPIManager(client: self)
        return character
    }
    
    func episode() -> EpisodeAPIManager {
        let episode = EpisodeAPIManager(client: self)
        return episode
    }
    
    func location() -> LocationAPIManager {
        let location = LocationAPIManager(client: self)
        return location
    }
}
