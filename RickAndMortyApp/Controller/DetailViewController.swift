//
//  DetailViewController.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 13.02.2021.
//

import UIKit



class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var episodeLabel: UILabel!
    
    var character: CharacterModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let character = character  else {
            return
        }
        
        if let url = URL(string: character.imageUrl) {
            imageView.load(url: url)
        }
        
        nameLabel.text = character.name
        statusLabel.text = character.status
        locationLabel.text = character.location
        episodeLabel.text = character.firstEpisode
    }
}



extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
