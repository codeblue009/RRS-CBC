//  RSSImageView.swift
//  CBC SACHA
//
//  Created by Sacha Sukhdeo on 2018-08-18.
//  Copyright © 2018 Sacha Sukhdeo. All rights reserved.

import Foundation
import UIKit

class RSSImageView: UIImageView {

    var link: URL? {
        get{
            return self.link
        }
        set(imageUrl) {
            startSpinner()
            if imageUrl != nil,
                let imageUrl = imageUrl {
                if let img = RSSImageCache.get(imageWithURL: imageUrl) {
                    super.image = img
                    self.stopSpinner()
                }
                else {
                    ImageDownloadService.downloadedFrom(url: imageUrl, callback: { image in
                        OperationQueue.main.addOperation {
                            super.image = image
                            RSSImageCache.add(image: image, url: imageUrl)
                            self.stopSpinner()
                        }
                    })
                }
            }
        }
    }
    
    var spinner: UIActivityIndicatorView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.bounds.size.height = 12 + self.bounds.size.width * 9/16
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 7
        self.layer.borderColor = UIColor.orange.cgColor
        self.backgroundColor = .orange
        self.clipsToBounds = true
    }
    
    func startSpinner() {
        let size = self.bounds.size
        if let spinner = spinner {
            spinner.isHidden = false
            spinner.startAnimating()
        } else {
            spinner = UIActivityIndicatorView.init(frame: CGRect.init(x: size.width/2 - 15,
                                                                      y: size.height/2 - 35,
                                                                      width: 35,
                                                                      height: 35))
            guard let spinner = spinner else { return }
            spinner.hidesWhenStopped = true
            spinner.startAnimating()
            self.addSubview(spinner)
            self.layoutSubviews()
        }
        
    }
    
    func stopSpinner() {
        self.layoutSubviews()
        if let spinner = spinner {
            spinner.stopAnimating()
        }
    }
    
}
