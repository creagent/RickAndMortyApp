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
        filters = CharacterFilterFactory.getAllCharacterFilters()
        didUpdate?()
    }
    
    func setFilters(withFilters filters: [Filter]) {
        self.filters = filters
    }
    
    func filterName(forFilterWithIndex index: Int) -> String {
        return filters[index].name
    }
    
    func currentFilterOptionValue(forFilterWithIndex index: Int) -> String {
        let filter = filters[index]
        return filter.options[filter.chosenOptionIndex].value
    }
    
    // MARK: - Private
    private var filters: [Filter] = CharacterFilterFactory.getAllCharacterFilters()
}
