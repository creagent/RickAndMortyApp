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
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(delegate: NSFetchedResultsControllerDelegate) {
        self.fetchedResultsController.delegate = delegate
    }
    
    func fetchAllCharacters() {
        try? fetchedResultsController.performFetch()
    }
    
    var fetchedResultsController: NSFetchedResultsController<CharacterModel> = {
        let request = CharacterModel.fetchRequest() as NSFetchRequest<CharacterModel>
        let sort = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
        
        return NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }()
}
