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
    static var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(fetchedResultsController: NSFetchedResultsController<CharacterModel>) {
        self.fetchedResultsController = fetchedResultsController
        Self.context = fetchedResultsController.managedObjectContext
    }
    
    func fetchAllCharacters() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController<CharacterModel>
}
