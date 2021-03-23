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
    var nameText: String?
    var locationText: String?
    var firstEpisodeText: String?
    var statusText: String?
    
    func setData() {
        nameLabel.text = nameText
        locationLabel.text = locationText
        episodeLabel.text = firstEpisodeText
        statusLabel.text = statusText
    }
}
