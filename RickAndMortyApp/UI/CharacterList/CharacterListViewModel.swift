//
//  CharacterListViewModel.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 19.03.2021.
//

import Foundation

class CharacterListViewModel {
    // MARK: - Public
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
    
    func loadCharactersFromFile() {
        characterFileManager.loadCharacterListFromFile(fileName: self.JSON_FILE_NAME) {
            [weak self] in switch $0 {
            case .success(let characters):
                guard let self = self else {
                    return
                }
                self.characters = characters
                self.didUpdate?()
            case.failure(let error):
                print(error)
            }
        }
        didFailInternetConnection?()
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
        fetchCharacters(pageNumber: 1)
    }
    
    func getNextPageCharacters() {
        shouldResetCharacterList = false
        if let nextPageNumber = nextPageNumber, nextPageNumber <= numberOfCharacterPages {
                fetchCharacters(pageNumber: nextPageNumber)
        }
    }
    
    // MARK: - Private constants
    private let characterFileManager = CharacterFileManager()
        
    private let JSON_FILE_NAME = "characters.json"
        
    // MARK: - Private
    private var filters: [Filter] = CharacterFilterFactory.getAllCharacterDefaultFilters()
    
    private var characters: [CharacterModel] = []
            
    private var nextPageNumber: Int? = 1
    
    private var searchText: String?
    
    private var shouldResetCharacterList = true
    
    private var numberOfCharacterPages = 1
    
    private var operationQueue = OperationQueue()
    
    // MARK: - Private functions
    private func fetchCharacters(pageNumber: Int) {
        let getCharacterInfoModelOperation = GetCharactersInfoModelOperation(page: pageNumber, name: searchText, filters: filters)
        let createLoadEpisodesOperation = CreateLoadEpisodesOperation()
        createLoadEpisodesOperation.addDependency(getCharacterInfoModelOperation)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.operationQueue.addOperations([getCharacterInfoModelOperation, createLoadEpisodesOperation], waitUntilFinished: true)
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
