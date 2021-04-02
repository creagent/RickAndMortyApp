//
//  FilterOptionsTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 31.03.2021.
//

import UIKit

class FilterOptionsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet private weak var filterOptionValueLabel: UILabel!
    
    // MARK: - Public
    var filterOptionValueText: String? {
        didSet {
            filterOptionValueLabel.text = filterOptionValueText
            filterOptionValueLabel.isHidden = filterOptionValueLabel == nil
        }
    }
}
