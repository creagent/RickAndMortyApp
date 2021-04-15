//
//  CharacterOriginModel+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 14.04.2021.
//
//

import Foundation
import CoreData


extension CharacterOriginModel {
    @NSManaged public var name: String
    @NSManaged public var url: String
    @NSManaged public var character: CharacterModel?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterOriginModel> {
        return NSFetchRequest<CharacterOriginModel>(entityName: "CharacterOriginModel")
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}
