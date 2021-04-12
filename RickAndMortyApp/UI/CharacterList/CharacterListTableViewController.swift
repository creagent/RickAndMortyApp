//
//  ListTableViewController.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 13.02.2021.
//

import UIKit

class CharacterListTVController: UITableViewController {
    // MARK: - IBActions
    @IBAction private func showFilterListButtonClickAction(_ sender: Any) {
        performSegue(withIdentifier: "showFilters", sender: self)
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCharactersToShow
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let characterCell = cell as? CharacterListTableViewCell {
            let index = indexPath.row
            let characterDetailViewModel = viewModel.characterDetailViewModel(atIndex: index)
            characterCell.nameText = characterDetailViewModel.characterName
            characterCell.locationText = characterDetailViewModel.characterLocation
            characterCell.firstEpisodeText = characterDetailViewModel.characterFirstEpisode
            characterCell.statusText = characterDetailViewModel.characterStatus
            characterCell.accessoryType = .disclosureIndicator
            
            return characterCell
        }
        return cell
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = listRefreshControl
        tableView.prefetchDataSource = self
        
        bindToViewModel()
        viewModel.refrechCharacterList()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        
        searchController.searchBar.delegate = self
        searchController.searchBar.showsBookmarkButton = true
        searchController.searchBar.setImage(UIImage(named: "sorting"), for: .bookmark, state: .normal)
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Navigation    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            let destinationVC = segue.destination as? CharacterDetailViewController
            destinationVC?.viewModel = viewModel.characterDetailViewModel(atIndex: indexPath.row)
        }
    }
    
    // MARK: - Private constants
    private let viewModel = CharacterListViewModel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Private
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else {
            return false
        }
        return text.isEmpty
    }
        
    // MARK: - Private functions
    private func bindToViewModel() {
        viewModel.didUpdate = {
            [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.didFailInternetConnection = {
            [weak self] in
            DispatchQueue.main.async {
                self?.showNoInternetConnectionAlert()
            }
        }
    }
    
    private func showNoInternetConnectionAlert() {
        DispatchQueue.main.async {
            let dialogMessage = UIAlertController(title: "Can't refresh right now", message: "Make sure your device is connected to the internet", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            dialogMessage.addAction(ok)
            self.present(dialogMessage, animated: true)
        }
    }
    
    // MARK: - Refreshing
    @objc private func refresh(sender: UIRefreshControl) {
        viewModel.refrechCharacterList()
        sender.endRefreshing()
    }
    
    private let listRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        let title = NSLocalizedString("Wait a second", comment: "Pull to refresh")
        refreshControl.attributedTitle = NSAttributedString(string: title)
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
}

// MARK: - UISearchResultsUpdating
extension CharacterListTVController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            tableView.refreshControl = nil
        }
        else {
            tableView.refreshControl = listRefreshControl
        }
        if searchController.isActive {
            viewModel.refrechCharacterList(forSearchText: searchController.searchBar.text)
        }
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension CharacterListTVController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        var indicies: [Int] = []
        indexPaths.forEach {
            indicies.append($0.row)
        }
        if indicies.contains(viewModel.numberOfCharactersToShow - 1) {
            viewModel.getNextPageCharacters()
        }
    }
}

// MARK: - UISearchBarDelegate
extension CharacterListTVController: UISearchBarDelegate {
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        let storyboard = UIStoryboard(name: "Filtering", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "filterList") as! FilterListTableViewController
        let filterListViewModel = viewModel.getFilterListViewModel()
        filterListViewModel.didAppliedFilters = { [weak self] filters in
            self?.viewModel.setFilters(withFilters: filters)
            self?.viewModel.refrechCharacterList(forSearchText: self?.searchController.searchBar.text)
            if !Filter.isDefaultFilters(filters) {
                self?.searchController.searchBar.setImage(UIImage(named: "sorting")?.withTintColor(.systemRed), for: .bookmark, state: .normal)
            } else {
                self?.searchController.searchBar.setImage(UIImage(named: "sorting"), for: .bookmark, state: .normal)
            }
        }
        viewController.viewModel = filterListViewModel
        show(viewController, sender: self)
    }
}
