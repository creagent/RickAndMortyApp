//
//  CharacterDataProvider.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 14.04.2021.
//

import Foundation
import CoreData
import UIKit

struct CharacterDataProvider {
    static var context: NSManagedObjectContext!
    
    init(delegate: NSFetchedResultsControllerDelegate) {
        fetchedResultsController.delegate = delegate
        DispatchQueue.main.async {
            CharacterDataProvider.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterModel")
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try CharacterDataProvider.context.fetch(fetchRequest)
                for object in results {
                    guard let objectData = object as? NSManagedObject else {continue}
                    CharacterDataProvider.context.delete(objectData)
                }
            } catch let error {
                print("Detele all data in CharacterModel error :", error)
            }
        }
    }
    
    func fetchAllCharacters() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController<CharacterModel> = {
        let request = CharacterModel.fetchRequest() as NSFetchRequest<CharacterModel>
        let sort = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }()
}
