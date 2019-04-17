//
//  UIImageView+Utils.swift
//  MovieRx
//
//  Created by Gustavo Henrique on 17/04/19.
//  Copyright © 2019 Gustavo Henrique. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {

    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode

        self.image = nil;

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }

            DispatchQueue.main.async() {
                let imageToCache = image
                imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
                self.image = image
            }

            }.resume()
    }

    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }

        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage{

            DispatchQueue.main.async() {
                self.image = cachedImage
            }

        } else {
            downloaded(from: url, contentMode: mode)
        }
    }
}
