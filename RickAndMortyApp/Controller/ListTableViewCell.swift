//
//  ListTableViewCell.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 13.02.2021.
//

import UIKit



class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var episodeLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!

    
    
    func setData(for character: CharacterModel) {
        nameLabel.text = character.name
        locationLabel.text = character.location
        episodeLabel.text = character.firstEpisode
        statusLabel.text = character.status
    }
}
