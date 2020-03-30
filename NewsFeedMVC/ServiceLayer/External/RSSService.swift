//
//  RSSService.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 29/10/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import Foundation

class RSSService: NSObject, RSSServiceProtocol {
    
    // MARK: - URLs
    
    private let urlLentaRu = URL(string: "https://lenta.ru/rss")
    private let urlGazetaRu = URL(string: "https://www.gazeta.ru/export/rss/lenta.xml")
    
    // MARK: - News
    
    private var lentaNews  = [NewsModel]()
    private var gazetaNews = [NewsModel]()
    
    private var feedNews: [NewsModel] {
        return lentaNews + gazetaNews
    }
    
    // MARK: - RSSService
    
    func fetchNews(_ completion: @escaping ([NewsModel]) -> ()) {
        
        let dispatchGroup = DispatchGroup()
        
        if let lentaURL = urlLentaRu {
            let lentaWorkItem = DispatchWorkItem { [weak self] in
                let newsParser: NewsParserProtocol = NewsParser()
                newsParser.fetchNewsAtUrl(lentaURL) { (news) in
                    self?.lentaNews = news
                }
            }
            DispatchQueue.global().async(group: dispatchGroup, execute: lentaWorkItem)
        }
        
        if let gazetaUrl = urlGazetaRu {
            let gazetaWorkItem = DispatchWorkItem { [weak self] in
                let newsParser: NewsParserProtocol = NewsParser()
                newsParser.fetchNewsAtUrl(gazetaUrl) { (news) in
                    self?.gazetaNews = news
                }
            }
            DispatchQueue.global().async(group: dispatchGroup, execute: gazetaWorkItem)
        }
        
        dispatchGroup.notify(queue: .global()) { [weak self] in
            if let news = self?.feedNews {
                completion(news)
            } else {
                completion([])
            }
        }
    }
}
