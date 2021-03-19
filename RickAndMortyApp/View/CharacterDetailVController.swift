//
//  DetailViewController.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 13.02.2021.
//

import UIKit



class CharacterDetailVController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var episodeLabel: UILabel!
    
    // MARK: - Public
    
    var viewModel: CharacterDetailDelegate?
    
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = viewModel else {
            return
        }
        
        viewModel.setCharacterImage(for: imageView)
        nameLabel.text = viewModel.character.name
        statusLabel.text = viewModel.character.status
        locationLabel.text = viewModel.character.location
        episodeLabel.text = viewModel.character.firstEpisode
    }
}
