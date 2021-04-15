//
//  CharacterOriginModel+CoreDataClass.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 14.04.2021.
//
//

import Foundation
import CoreData

@objc(CharacterOriginModel)
public class CharacterOriginModel: NSManagedObject, Decodable, Identifiable {
    required public convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
    }
}
