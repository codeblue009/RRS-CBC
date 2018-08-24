//
//  ImageDownloadService.swift
//  CBC SACHA
//
//  Created by Sacha Sukhdeo on 2018-08-15.
//  Copyright © 2018 Sacha Sukhdeo. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloadService {
    
    static func imageView(withImagefromLink link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) -> UIImageView? {
        guard let url = URL(string: link) else { return nil }
        return UIImageView().downloadedFrom(url: url, contentMode: mode)
    }
    
    static func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit, callback: @escaping (_ image: UIImage) -> Void) {

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType,
                mimeType.hasPrefix("image"),
                let data = data,
                error == nil,
                let image = UIImage(data: data)
                else { return }
            callback(image)
            }.resume()
        
    }
}
