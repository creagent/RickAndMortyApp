//
//  StatusFilter.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 30.03.2021.
//

import Foundation

struct CharacterFilterFactory {
    // MARK: - Public
    static func getAllCharacterFilters() -> [Filter] {
        return [getFilter(ofType: .gender), getFilter(ofType: .status)]
    }
    
    static func getFilter(ofType type: CharacterFilterType) -> Filter {
        let filter: Filter
        let options: [Option]
        switch type {
        case .gender:
            options = [
                Option(value: "Any"),
                Option(value: "Male"),
                Option(value: "Female"),
                Option(value: "Genderless"),
                Option(value: "Unknown")
            ]
            filter = Filter(name: "Gender", options: options)
        case .status:
            options = [
                Option(value: "Any"),
                Option(value: "Alive"),
                Option(value: "Dead"),
                Option(value: "Unknown")
            ]
            filter = Filter(name: "Status", options: options)
        }
        return filter
    }
}

struct Filter {
    let name: String
    let options: [Option]
    var chosenOptionIndex: Int = 0
}

struct Option {
    let value: String
}

enum CharacterFilterType {
    case gender, status
}


