//
//  RSSFeedService.swift
//  CBC SACHA
//
//  Created by Sacha Sukhdeo on 2018-08-15.
//  Copyright © 2018 Sacha Sukhdeo. All rights reserved.

import Foundation

class RSSFeedService {

    let rssParseService = RSSParseService()
    
    func getTopStories() -> Array<Article> {
        if Reachability.isConnectedToNetwork() == true {
            rssParseService.parseRSS(fromURL: "https://www.cbc.ca/cmlink/rss-topstories")
        }
        else {
            Reachability.showNoConnectionAlert()
        }
        return rssParseService.parsedArticles
    }
    
}
