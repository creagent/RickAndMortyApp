//
//  Client.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 18.02.2021.
//

import Foundation



struct Client {
    
    func character() -> Character {
        let character = Character(client: self)
        return character
    }
    
    func episode() -> Episode {
        let episode = Episode(client: self)
        return episode
    }
    
    func location() -> Location {
        let location = Location(client: self)
        return location
    }
}
