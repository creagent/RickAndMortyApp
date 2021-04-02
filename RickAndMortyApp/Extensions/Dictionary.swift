//
//  Dictionary.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 02.04.2021.
//

import Foundation

extension Dictionary {
    mutating func merge (_ dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
}
