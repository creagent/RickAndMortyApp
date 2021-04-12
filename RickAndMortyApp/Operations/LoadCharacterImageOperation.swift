//
//  LoadCharacterImageOperation.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 12.04.2021.
//

import Foundation
import UIKit

class LoadCharacterImageOperation: AsyncOperation {
    init(url: URL) {
        self.url = url
    }
    
    override func main() {
        ImageService.loadImage(fromUrl: url) {
            [weak self] image in
            self?.image = image
            self?.state = .finished
        }
    }
    
    var image: UIImage?
    
    private let url: URL
}
