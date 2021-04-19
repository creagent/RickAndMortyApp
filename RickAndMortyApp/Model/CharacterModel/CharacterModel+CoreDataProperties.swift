//
//  CharacterModel+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 14.04.2021.
//
//

import Foundation
import CoreData


extension CharacterModel {

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var status: String
    @NSManaged public var species: String
    @NSManaged public var type: String
    @NSManaged public var gender: String
    @NSManaged public var origin: CharacterOriginModel
    @NSManaged public var location: CharacterLocationModel
    @NSManaged public var image: String
    @NSManaged public var episodeUrls: Set<String>
    @NSManaged public var episodes: Set<EpisodeModel>?
    @NSManaged public var urlString: String
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterModel> {
        return NSFetchRequest<CharacterModel>(entityName: "CharacterModel")
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case species
        case type
        case gender
        case origin
        case location
        case image
        case episodeUrls = "episode"
        case urlString = "url"
    }
}
