//
//  CharacterLocationModel+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 14.04.2021.
//
//

import Foundation
import CoreData


extension CharacterLocationModel {
    @NSManaged public var name: String
    @NSManaged public var url: String
    @NSManaged public var character: CharacterModel?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterLocationModel> {
        return NSFetchRequest<CharacterLocationModel>(entityName: "CharacterLocationModel")
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}
