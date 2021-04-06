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
    
    var numberOfCharactersToShow: Int {
        return characters.count
    }
    
    func characterDetailViewModel(atIndex index: Int) -> CharacterDetailViewModel {
        return CharacterDetailViewModel(character: characters[index])
    }
    
    func refrechCharacterList(forSearchText searchText: String? = nil) {
        self.searchText = searchText
        fetchCharacters(pageNumber: 1, shouldReset: true)
        if searchText == nil {
            loadAllEpisodes()
        }
        refreshDispatchGroup.notify(queue: .global(qos: .userInitiated)) {
            [weak self] in
            guard let self = self else {
                return
            }
            self.setEpisodeNameForCharacterList(fromStartingIndex: 0)
            if searchText == nil {
                self.characterFileManager.saveCharcterListToFile(characters: self.characters, fileName: self.JSON_FILE_NAME)
            }
        }
    }
    
    func getNextPageCharacters() {
        if let nextPageNumber = nextPageNumber, nextPageNumber <= numberOfCharacterPages {
                fetchCharacters(pageNumber: nextPageNumber, shouldReset: false)
        }
    }
    
    // MARK: - Private constants
    private let characterAPIManager = CharacterAPIManager()
    
    private let characterFileManager = CharacterFileManager()
    
    private let episodeAPIManager = EpisodeAPIManager()
    
    private let JSON_FILE_NAME = "characters.json"
    
    private let refreshDispatchGroup = DispatchGroup()
    
    // MARK: - Private
    private var filters: [Filter] = CharacterFilterFactory.getAllCharacterDefaultFilters()
    
    private var characters: [CharacterModel] = []
        
    private var allEpisodes: [EpisodeModel] = []
    
    private var nextPageNumber: Int? = 1
    
    private var searchText: String?
    
    private var numberOfCharacterPages = 1
    
    // MARK: - Private functions
    private func fetchCharacters(pageNumber: Int, shouldReset: Bool) {
        refreshDispatchGroup.enter()
        self.characterAPIManager.getCharacterInfoModel(page: pageNumber, name: searchText, filters: filters) {
            [weak self] in switch $0 {
            case .success(let characterInfoModel):
                guard let self = self else {
                    return
                }
                self.numberOfCharacterPages = characterInfoModel.info.pages
                self.nextPageNumber = self.getNextPageNumber(fromUrlString: characterInfoModel.info.nextPageUrl)
                if shouldReset {
                    self.characters = []
                }
                let oldCharactersCount = self.characters.count
                self.characters += characterInfoModel.results
                if !shouldReset {
                    self.setEpisodeNameForCharacterList(fromStartingIndex: oldCharactersCount)
                }
                self.didUpdate?()
                
            case.failure(let error):
                print(error)
                guard let self = self else {
                    return
                }
                self.characterFileManager.loadCharacterListFromFile(fileName: self.JSON_FILE_NAME) {
                    [weak self] in switch $0 {
                    case .success(let characters):
                        guard let self = self else {
                            return
                        }
                        self.characters = characters
                        self.didUpdate?()
                        self.setEpisodeNameForCharacterList(fromStartingIndex: 0)
                    case.failure(let error):
                        print(error)
                    }
                }
                self.didFailInternetConnection?()
            }
        self?.refreshDispatchGroup.leave()
        }
    }
    
    private func loadAllEpisodes() {
        refreshDispatchGroup.enter()
        self.episodeAPIManager.getAllEpisodes { [weak self] in
            switch $0 {
            case .success(let episodes):
                guard let self = self else {
                    return
                }
                self.allEpisodes = episodes
            case .failure(let error):
                print(error)
                self?.didFailInternetConnection?()
            }
            self?.refreshDispatchGroup.leave()
        }
    }
    
    private func setEpisodeNameForCharacterList(fromStartingIndex: Int) {
        if !allEpisodes.isEmpty {
            for i in fromStartingIndex..<characters.count {
                var character = characters[i]
                for j in 0..<character.episodeUrls.count {
                    let episodeUrl = character.episodeUrls[j]
                    guard let idString = episodeUrl.split(separator: "/").last else {
                        continue
                    }
                    guard let id = Int(idString) else {
                        continue
                    }
                    // Episodes indecies start from 1 but array starst from 0
                    if character.episodes == nil {
                        character.episodes = []
                    }
                    character.episodes?.append(allEpisodes[id - 1])
                }
                characters[i] = character
            }
            didUpdate?()
        }
    }
    
    private func getNextPageNumber(fromUrlString urlString: String?) -> Int? {
        guard let urlString = urlString else {
            return nil
        }
        guard let url = URLComponents(string: urlString) else {
            return 1
        }
        guard let pageNumber = Int(url.queryItems?.first(where: { $0.name == "page" })?.value ?? "1") else {
            return 1
        }
        return pageNumber
    }
}
