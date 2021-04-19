//
//  CharacterListViewModel.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 19.03.2021.
//

import Foundation

class CharacterListViewModel {
    // MARK: - Public
    init(characterDataProvider: CharacterDataProvider) {
        self.characterDataProvider = characterDataProvider
    }
    
    var didUpdate: (() -> Void)?
    
    var didFailInternetConnection: (() -> Void)?
        
    func setFilters(withFilters filters: [Filter]) {
        self.filters = filters
    }
    
    func getFilterListViewModel() -> FilterListViewModel{
        let viewModel = FilterListViewModel()
        viewModel.setFilters(withFilters: filters)
        return viewModel
    }
    
    func getCharactersFromDataProvider() {
        characters = characterDataProvider.fetchedResultsController.fetchedObjects ?? []
        didUpdate?()
    }
    
    var numberOfCharactersToShow: Int {
        return characters.count
    }
    
    func characterDetailViewModel(atIndex index: Int) -> CharacterDetailViewModel {
        return CharacterDetailViewModel(character: characters[index])
    }
    
    func refrechCharacterList(forSearchText searchText: String? = nil) {
        operationQueue.cancelAllOperations()
        self.searchText = searchText
        shouldResetCharacterList = true
        fetchCharacters(pageNumber: 1, shouldClearDatabase: true)
    }
    
    func getNextPageCharacters() {
        shouldResetCharacterList = false
        if let nextPageNumber = nextPageNumber, nextPageNumber <= numberOfCharacterPages {
            fetchCharacters(pageNumber: nextPageNumber)
        }
    }
                
    // MARK: - Private
    private var filters: [Filter] = CharacterFilterFactory.getAllCharacterDefaultFilters()
    
    private var characters: [CharacterModel] = []
            
    private var nextPageNumber: Int? = 1
    
    private var searchText: String?
    
    private var shouldResetCharacterList = true
        
    private var numberOfCharacterPages = 1
    
    private let characterDataProvider: CharacterDataProvider
    
    private var operationQueue = OperationQueue()
    
    // MARK: - Private functions
    private func fetchCharacters(pageNumber: Int, shouldClearDatabase: Bool = false) {
        let getCharacterInfoModelOperation = GetCharactersInfoModelOperation(page: pageNumber, name: searchText, filters: filters, shouldClearDatabase: shouldClearDatabase)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.operationQueue.addOperations([getCharacterInfoModelOperation], waitUntilFinished: true)
            
            self.characterDataProvider.fetchAllCharacters()
            self.characters = self.characterDataProvider.fetchedResultsController.fetchedObjects ?? []
            let createLoadEpisodesOperation = CreateLoadEpisodesOperation(characters: self.characters)
            self.operationQueue.addOperations([createLoadEpisodesOperation], waitUntilFinished: true)

            if (self.searchText == nil || self.searchText == "") && Filter.isDefaultFilters(self.filters) {
                self.characterDataProvider.fetchAllCharacters()
                self.characters = self.characterDataProvider.fetchedResultsController.fetchedObjects ?? []
            } else {
                if self.shouldResetCharacterList {
                    self.characters = getCharacterInfoModelOperation.characters ?? []
                } else {
                    self.characters += getCharacterInfoModelOperation.characters ?? []
                }
                self.nextPageNumber = getCharacterInfoModelOperation.nextPageNumber
                self.numberOfCharacterPages = getCharacterInfoModelOperation.numberOfCharacterPages ?? 1
                self.didUpdate?()
            }
        }
    }
}
