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

typealias NetworkCompletion = (_ models: [NewsModel]) -> ()

protocol NewsParserProtocol {
    func fetchNewsAtUrl(_ url: URL, completion: @escaping NetworkCompletion)
}


class NewsParser: NSObject, NewsParserProtocol {
    
    
    
    private var newsModel: NewsModel!
    private var models = [NewsModel]()
    
    func fetchNewsAtUrl(_ url: URL, completion: @escaping NetworkCompletion) {
        AF.request(url).validate().response { (response) in
            switch response.result {
            case .success:
                if let data = response.data {
                    let xml = XML.parse(data)
                    var itemNumber = 0
                    
                    while xml.rss.channel.item[itemNumber].text != nil {
                        
                        self.newsModel = NewsModel()
                        
                        //                    self.newsModel.newsResource     = xml["rss"]["channel"]["item"][itemNumber]["link"].text ?? ""
                        self.newsModel.newsResource     = xml["rss"]["channel"]["title"].text ?? ""
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
                    
                    //                print("News resource: \(uniqueModels[0].newsResource)")
                    //                print("News link: \(uniqueModels[0].newsLink)")
                    //                print("News title: \(uniqueModels[0].newsTitle)")
                    //                print("News description: \(uniqueModels[0].newsDescription)")
                    //                print("News imageURL: \(uniqueModels[0].imageURL)")
                    //                print("News date: \(uniqueModels[0].dateOfCreation)")
                    //                print("News category: \(uniqueModels[0].category)")
                    
                    completion(uniqueModels)
                }

            case let .failure(error):
                print("Handling ERROR: \(error.localizedDescription)")
                
                completion([])
            }
        }
    }
}
