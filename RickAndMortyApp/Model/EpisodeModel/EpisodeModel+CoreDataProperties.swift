//
//  EpisodeModel+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 14.04.2021.
//
//

import Foundation
import CoreData


extension EpisodeModel {
    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var airDate: String
    @NSManaged public var episode: String
    @NSManaged public var characters: Set<CharacterModel>?
    @NSManaged public var url: String
    @NSManaged public var created: String
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EpisodeModel> {
        return NSFetchRequest<EpisodeModel>(entityName: "EpisodeModel")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case episode
        case url
        case created
        case airDate = "air_date"
    }
}
