//
//  ListTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 13.02.2021.
//

import UIKit

class CharacterListTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var locationLabel: UILabel!
    @IBOutlet weak private var episodeLabel: UILabel!
    @IBOutlet weak private var statusLabel: UILabel!
    
    // MARK: - Public
    var nameText: String? {
        didSet {
            nameLabel.text = nameText
        }
    }
    
    var locationText: String? {
        didSet {
            locationLabel.text = locationText
        }
    }
    
    var firstEpisodeText: String? {
        didSet {
            episodeLabel.text = firstEpisodeText
        }
    }
    
    var statusText: String? {
        didSet {
            statusLabel.text = statusText
        }
    }
}
