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
    
    func parseRSS(fromURL urlString: String) {
        if let url = URL(string: urlString),
            let parser = XMLParser(contentsOf: url) {
            parser.delegate = self
            parsedArticles = []
            parser.parse()
        }
    }
    
    func parseType(byTag tag: String) {
        if isNewItem {
            switch tag {
            case "title": isTitle = true
                break
            case "author": isAuthor = true
                break
            case "link": isLink = true
                break
            case "pubDate": isDate = true
                break
            default: break
            }
        }
        else if tag == "item" {
            isNewItem = true
            currentArticle = Article()
        }
    }
    
    func parseNewItemTag(tag: String) {
        if tag == "item" {
            isNewItem = false
            if let article = currentArticle {
                parsedArticles.append(article)
            }
        }
    }
    
    func parseArticle(characters string: String) {
        
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
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        parseType(byTag: elementName)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        parseNewItemTag(tag: elementName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        parseArticle(characters: string)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError)
    }
    
}
