//
//  FilterOptionsTableViewController.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 30.03.2021.
//

import UIKit

class FilterOptionsTableViewController: UITableViewController {
    // MARK: - Public
    var viewModel: FilterOptionsViewModel?
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfFilterOptionsToShow ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterOptionCell", for: indexPath)
        if let filterOptionCell = cell as? FilterOptionsTableViewCell {
            guard let viewModel = viewModel else {
                return cell
            }
            filterOptionCell.filterOptionValueText = viewModel.filterOptionValue(atIndex: indexPath.row)
            if viewModel.isFilterOptionChosen(atIndex: indexPath.row) {
                filterOptionCell.accessoryType = .checkmark
            }
            else {
                filterOptionCell.accessoryType = .none
            }
            return filterOptionCell
        }
        return cell
    }
     
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.setChosenOption(toOptionAtIndex: indexPath.row)
    }
    
    // MARK: - LIfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel?.filterName
        bindToViewModel()
    }
    
    // MARK: - Private functions
    private func bindToViewModel() {
        viewModel?.didUpdate = { [weak self] in
            self?.tableView.reloadData()
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
