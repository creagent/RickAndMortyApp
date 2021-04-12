//
//  DetailViewController.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 13.02.2021.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    
    // MARK: - Public
    var viewModel: CharacterDetailViewModel? {
        didSet {
            viewModel?.delegate = self
        }
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let viewModel = viewModel else {
            return
        }
        viewModel.setCharacterImage()
        nameLabel.text = viewModel.characterName
        statusLabel.text = viewModel.characterStatus
        locationLabel.text = viewModel.characterLocation
        episodeLabel.text = viewModel.characterFirstEpisode
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.cancelImageLoading()
    }
}

extension CharacterDetailViewController: CharacterDetailViewModelDelegate {
    func didLoadCharacterImage(image: UIImage) {
        DispatchQueue.main.async {
            [weak self] in
            self?.imageView.image = image
        }
    }
}
