//
//  FilterListViewModel.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 30.03.2021.
//

import Foundation

class FilterListViewModel {
    // MARK: - Public
    var numberOfFiltersToShow: Int {
        return filters.count
    }
    
    var didUpdate: (() -> Void)?
    
    var didAppliedFilters: (([Filter]) -> Void)?
    
    var didClearedFilters: (() -> Void)?
    
    func applyFilters() {
        didAppliedFilters?(filters)
    }
    
    func filterOptionsViewModel(atIndex index: Int) -> FilterOptionsViewModel {
        let viewModel = FilterOptionsViewModel(filter: filters[index])
        viewModel.didOptionChosen = { [weak self] filter in
            self?.filters[index] = filter
            self?.didUpdate?()
        }
        return viewModel
    }
    
    func clearFilters() {
        filters.forEach {
            $0.setDefaultOption()
        }
        didUpdate?()
        didClearedFilters?()
    }
    
    func setFilters(withFilters filters: [Filter]) {
        self.filters = filters
    }
    
    func filterName(forFilterWithIndex index: Int) -> String {
        return filters[index].name
    }
    
    func currentFilterOptionValue(forFilterWithIndex index: Int) -> String {
        let filter = filters[index]
        return filter.options[filter.chosenOptionIndex].valueString
    }
    
    // MARK: - Private
    private var filters: [Filter] = CharacterFilterFactory.getAllCharacterDefaultFilters()
}
