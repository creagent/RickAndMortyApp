//
//  FilterOptionsViewModel.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 30.03.2021.
//

import Foundation

class FilterOptionsViewModel {
    // MARK: - Public
    init(filter: Filter) {
        filterName = filter.name
        self.filter = filter
    }
    
    var didUpdate: (() -> Void)?
    
    var didOptionChosen: ((Filter) -> Void)?
    
    var numberOfFilterOptionsToShow: Int {
        return filter.options.count
    }
    
    func isFilterOptionChosen(atIndex index: Int) -> Bool {
        return index == filter.chosenOptionIndex
    }
    
    func setChosenOption(toOptionAtIndex index: Int) {
        filter.chosenOptionIndex = index
        didOptionChosen?(filter)
        didUpdate?()
    }
    
    func filterOptionValue(atIndex index: Int) -> String {
        return filter.options[index].value
    }
    
    let filterName: String
        
    // MARK: - Private    
    private var filter: Filter
}
