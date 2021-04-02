//
//  StatusFilter.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 30.03.2021.
//

import Foundation

struct CharacterFilterFactory {
    // MARK: - Public
    static func getAllCharacterDefaultFilters() -> [Filter] {
        return [getFilter(ofType: .gender), getFilter(ofType: .status)]
    }
    
    static func getFilter(ofType type: CharacterFilterType) -> Filter {
        let filter: Filter
        let options: [Option]
        switch type {
        case .gender:
            options = [
                Option(value: "any", valueString: "Any"),
                Option(value: "male", valueString: "Male"),
                Option(value: "female", valueString: "Female"),
                Option(value: "genderless", valueString: "Genderless"),
                Option(value: "unknown", valueString: "Unknown")
            ]
            filter = Filter(name: "Gender", options: options)
        case .status:
            options = [
                Option(value: "any", valueString: "Any"),
                Option(value: "alive", valueString: "Alive"),
                Option(value: "dead", valueString: "Dead"),
                Option(value: "unknown", valueString: "Unknown")
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
    
    var filterDict: [String: Any?] {
        let value = options[chosenOptionIndex].value
        if value != "any" {
            return [name.lowercased(): options[chosenOptionIndex].value]
        }
        else {
            return [:]
        }
    }
}

struct Option {
    let value: String
    let valueString: String
}

enum CharacterFilterType {
    case gender, status
}


