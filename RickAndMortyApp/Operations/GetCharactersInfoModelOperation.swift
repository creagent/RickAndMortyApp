//
//  GetCharactersInfoModelOperation.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 07.04.2021.
//
 
import Foundation
import UIKit

class GetCharactersInfoModelOperation: AsyncOperation {
    // MARK: - Public
    init(page: Int? = nil, name: String? = nil, filters: [Filter]? = nil, shouldClearDatabase: Bool = false) {
        self.page = page
        characterName = name
        self.filters = filters
        self.shouldClearDatabase = shouldClearDatabase
    }
    
    override func main() {
        guard !isCancelled else { return }
        print("\n\n\nCharacters loading...\n\n\n")
        let characterAPIManager = CharacterAPIManager()
        dataTask = characterAPIManager.getCharacterInfoModel(page: page, name: characterName, filters: filters) { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case .success(let characterInfoModel):
                self.numberOfCharacterPages = characterInfoModel.info.pages
                self.nextPageNumber = self.getNextPageNumber(fromUrlString: characterInfoModel.info.nextPageUrl)
                self.characters = characterInfoModel.results
                
                if (self.characterName == nil || self.characterName == "") && (self.filters == nil || Filter.isDefaultFilters(self.filters)) {
                    DatabaseManager.save(shouldReset: self.shouldClearDatabase)
                } else {
                    if CharacterDataProvider.context.hasChanges {
                        CharacterDataProvider.context.rollback()
                    }
                }
            case.failure(let error):
                print(error)
            }
            print("\n\n\nFinished characters loading!\n\n\n")
            self.state = .finished
        }
    }
    
    var characters: [CharacterModel]?
    var nextPageNumber: Int?
    var numberOfCharacterPages: Int?
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
    
    // MARK: - Private constants
    private let page: Int?
    private let characterName: String?
    private let filters: [Filter]?
    private let shouldClearDatabase: Bool
    
    // MARK: - Private
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Private functions
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
