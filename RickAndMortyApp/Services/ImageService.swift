//
//  ImageService.swift
//  RickAndMortyApp
//
//  Created by Антон Алексеев on 23.03.2021.
//

import Foundation
import UIKit

struct ImageService {
    // MARK: - Public
    static func loadImage(fromUrl url: URL, completion: @escaping (UIImage) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    completion(image)
                }
            }
        }
    }
}
