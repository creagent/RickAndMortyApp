//
//  CharacterModel+CoreDataClass.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 14.04.2021.
//
//

import Foundation
import CoreData

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

@objc(CharacterModel)
public class CharacterModel: NSManagedObject, Decodable, Identifiable {
    required public convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        print("\n\n\n\(#function) \(context)\n\n\n")
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.status = try container.decode(String.self, forKey: .status)
        self.species = try container.decode(String.self, forKey: .species)
        self.type = try container.decode(String.self, forKey: .type)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.origin = try container.decode(CharacterOriginModel.self, forKey: .origin)
        self.location = try container.decode(CharacterLocationModel.self, forKey: .location)
        self.image = try container.decode(String.self, forKey: .image)
        self.episodeUrls = try container.decode(Set<String>.self, forKey: .episodeUrls)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.urlString = try container.decode(String.self, forKey: .urlString)
    }
}
