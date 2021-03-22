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
    func setData(for character: CharacterModel) {
        nameLabel.text = character.name
        locationLabel.text = character.location
        episodeLabel.text = character.firstEpisode
        statusLabel.text = character.status
    }
}
