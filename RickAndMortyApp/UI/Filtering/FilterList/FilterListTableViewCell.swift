//
//  FilterListTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 31.03.2021.
//

import UIKit

class FilterListTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private weak var filterNameLabel: UILabel!
    @IBOutlet private weak var filterCurrentOptionLabel: UILabel!
    
    // MARK: - Public
    var filterNameText: String? {
        didSet {
            filterNameLabel.text = filterNameText
            filterNameLabel.isHidden = filterNameText == nil
        }
    }
    
    var filterCurrentOptionText: String? {
        didSet {
            filterCurrentOptionLabel.text = filterCurrentOptionText
            filterCurrentOptionLabel.isHidden = filterCurrentOptionText == nil
        }
    }
    
}
