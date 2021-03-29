//
//  Info.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 29.03.2021.
//

import Foundation

struct InfoModel<T: Decodable>: Decodable {
    let info: Info
    let results: [T]
}
