//
//  Article.swift
//  CBC SACHA
//
//  Created by Sacha Sukhdeo on 2018-08-15.
//  Copyright © 2018 Sacha Sukhdeo. All rights reserved.

import Foundation
import UIKit

class Article {

    var title: String?
    var date: String?
    var author: String?
    var link: URL?
    var imageUrl: URL?
    var imageUrlString: String? {
        get {
            return imageUrl?.absoluteString
        }
        set(url) {
            if let url = url {
                let urlCleaned = url.replacingOccurrences(of: "\'", with: "")
                imageUrl = URL(string: urlCleaned)
            }
        }
    }
    
    init() {}

}
