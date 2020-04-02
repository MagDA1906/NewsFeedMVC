//
//  NewsParserProtocol.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 29/10/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyXMLParser

protocol NewsParserProtocol {
    func fetchNewsAtUrl(_ url: URL, completion: @escaping ([NewsModel]) -> ())
}


class NewsParser: NSObject, NewsParserProtocol {
    
    private var newsModel: NewsModel!
    private var models = [NewsModel]()
    
    func fetchNewsAtUrl(_ url: URL, completion: @escaping ([NewsModel]) -> ()) {
        print(url)
        AF.request(url).response { (response) in
            if let data = response.data {
                let xml = XML.parse(data)
                var itemNumber = 0
                
                while xml.rss.channel.item[itemNumber].text != nil {

                    self.newsModel = NewsModel()

                    self.newsModel.newsResource     = xml["rss"]["channel"]["item"][itemNumber]["link"].text ?? ""
                    self.newsModel.newsLink         = xml["rss"]["channel"]["item"][itemNumber]["link"].text ?? ""
                    self.newsModel.newsTitle        = xml["rss"]["channel"]["item"][itemNumber]["title"].text ?? ""
                    self.newsModel.newsDescription  = xml["rss"]["channel"]["item"][itemNumber]["description"].text ?? ""
                    self.newsModel.imageURL         = xml["rss"]["channel"]["item"][itemNumber]["enclosure"].attributes["url"] ?? ""
                    self.newsModel.dateOfCreation   = xml["rss"]["channel"]["item"][itemNumber]["pubDate"].text ?? ""
                    self.newsModel.category         = xml["rss"]["channel"]["item"][itemNumber]["category"].text ?? ""

                    self.models.append(self.newsModel)
                    itemNumber += 1
                }
                let uniqueModels = self.models.removingDuplicates()
                completion(uniqueModels)
            }
        }
    }
}
