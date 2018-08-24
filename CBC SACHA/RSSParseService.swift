//
//  ParseXMLService.swift
//  CBC SACHA
//
//  Created by Sacha Sukhdeo on 2018-08-15.
//  Copyright © 2018 Sacha Sukhdeo. All rights reserved.
//

import Foundation

class RSSParseService: NSObject, XMLParserDelegate {
    
    var parsedArticles: Array<Article> = []
    var currentArticle: Article?
    var isNewItem = false
    var isTitle = false
    var isAuthor = false
    var isDate = false
    var isLink = false
    var isDescription = false
    
    func parseRSS(fromURL urlString: String) {
        if let url = URL(string: urlString),
            let parser = XMLParser(contentsOf: url) {
            parser.delegate = self
            parsedArticles = []
            parser.parse()
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if isNewItem {
            switch elementName {
            case "title": isTitle = true
                break
            case "author": isAuthor = true
                break
            case "link": isLink = true
                break
            case "pubDate": isDate = true
                break
            case "description": isDescription = true
                break
            default: break
            }
        }
        else if elementName == "item" {
            isNewItem = true
            currentArticle = Article()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            isNewItem = false
            if let article = currentArticle {
                parsedArticles.append(article)
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard let article = currentArticle else { return }
        if isTitle {
            article.title = string
            isTitle = false
        }
        else if isAuthor {
            article.author = string
            isAuthor = false
        }
        else if isDate {
            article.date = string
            isDate = false
        }
        else if isLink {
            article.link = URL(string: string)
            isLink = false
        }
        else if (article.imageUrlString == nil) {
            let matches = string.matches(regex: "'(.*?)'")
            if matches.count > 0,
                let urlString = matches.first {
                article.imageUrlString = urlString
                if let imageUrl = article.imageUrl {
                    ImageDownloadService.downloadedFrom(url: imageUrl, callback: { image in
                        RSSImageCache.add(image: image, url: imageUrl)
                    })
                }
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
    }
    
}
