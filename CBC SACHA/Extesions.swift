//
//  Extesions.swift
//  CBC SACHA
//
//  Created by Sacha Sukhdeo on 2018-08-16.
//  Copyright © 2018 Sacha Sukhdeo. All rights reserved.
//

import Foundation
import UIKit

extension String {

    func matches(regex: String) -> Array<String> {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
}

extension UIImageView {
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) -> UIImageView {
        
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
            self.image = image
            }.resume()
        
        return self
    }
    
}
