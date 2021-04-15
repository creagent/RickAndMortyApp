//
//  DatabseManager.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 13.04.2021.
//

import Foundation
import CoreData
import UIKit

struct DatabaseManager {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func save(shouldReset: Bool = false) {
        if shouldReset {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CharacterModel")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            DispatchQueue.main.async {
                do {
                    try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
                } catch {
                    print(error)
                }
            }
        }
        DispatchQueue.main.async {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}
