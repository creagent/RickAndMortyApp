//
//  EpisodeModel+CoreDataClass.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 14.04.2021.
//
//

import Foundation
import CoreData

@objc(EpisodeModel)
public class EpisodeModel: NSManagedObject, Decodable, Identifiable {
    required public convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.airDate = try container.decode(String.self, forKey: .airDate)
        self.episode = try container.decode(String.self, forKey: .episode)
        self.url = try container.decode(String.self, forKey: .url)
        self.created = try container.decode(String.self, forKey: .created)
    }
}
