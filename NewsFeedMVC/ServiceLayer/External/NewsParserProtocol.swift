//
//  NewsParserProtocol.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 29/10/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import Foundation

protocol NewsParserProtocol {
    func fetchNewsAtUrl(_ url: URL, completion: @escaping ([NewsModel]) -> ())
}


class NewsParser: NSObject, NewsParserProtocol {
    
    private var currentTag: String?
    private var itemFlag = false
    private var channelFlag = false
    private var resource = ""
    
    private var news: NewsModel?
    private var feedNews = [NewsModel]()
    
    func fetchNewsAtUrl(_ url: URL, completion: @escaping ([NewsModel]) -> ()) {
        
        guard let parser = XMLParser(contentsOf: url) else {
            completion([])
            return
        }
        
        parser.delegate = self
        parser.parse()
        completion(feedNews)
    }
}

extension NewsParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Parse ERROR: \(parseError)")
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentTag = elementName
        if elementName == "item" {
            news = NewsModel(newsResource: "", newsLink: "", newsTitle: "", newsDescription: "", dateOfCreation: "", imageURL: "", category: "")
            itemFlag = true
        }
        
        if elementName == "enclosure" {
            let attrsUrl = attributeDict as [String:String]
            let urlPic = attrsUrl["url"]
            guard let imageURL = urlPic else {
                return
            }
            news?.imageURL = imageURL
        }
        
        if elementName == "channel" {
            channelFlag = true
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            news?.newsResource = resource
            if let news = news {
                feedNews.append(news)
                print("Title: \(news.newsTitle) NewsResource: \(news.newsResource) Category: \(news.category)")
            }
            news = nil
            itemFlag = false
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if itemFlag {
            if let tempNews = news {
                if let tempElement = currentTag {
                    switch tempElement {
                    case "title":
                        news?.newsTitle = tempNews.newsTitle + string
                    case "description":
                        news?.newsDescription = tempNews.newsDescription + string
                    case "link":
                        news?.newsLink = tempNews.newsLink + string
                    case "pubDate":
                        news?.dateOfCreation = tempNews.dateOfCreation + string
                    case "category":
                        news?.category = tempNews.category + string
                    default:
                        break
                    }
                }
            }
        }
        if channelFlag {
            if currentTag == "title" {
                resource = resource + string
                channelFlag = false
            }
        }
    }
}
