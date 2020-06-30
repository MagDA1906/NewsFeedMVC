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
    
    private var lentaNews: [NewsModel]?
    private var gazetaNews: [NewsModel]?
    
    private var feedNews: [NewsModel]? {
        if lentaNews != nil, gazetaNews != nil {
            return lentaNews! + gazetaNews!
        }
        return nil
    }
    
    private var error: Error?
    
    // MARK: - RSSService
    
    func fetchNews(_ completion: @escaping ([NewsModel]?, _ error: Error?) -> ()) {
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        if let lentaURL = urlLentaRu {
            let lentaWorkItem = DispatchWorkItem { [weak self] in
                let newsParser: NewsParserProtocol = NewsParser()
                newsParser.fetchNewsAtUrl(lentaURL) { (news, error) in
                    if let news = news {
                        self?.lentaNews = news
                    }
                    if let error = error {
                        self?.error = error
                    }
                    dispatchGroup.leave()
                }
            }
            DispatchQueue.global().async(group: dispatchGroup, execute: lentaWorkItem)
        }
        
        dispatchGroup.enter()
        if let gazetaUrl = urlGazetaRu {
            let gazetaWorkItem = DispatchWorkItem { [weak self] in
                let newsParser: NewsParserProtocol = NewsParser()
                newsParser.fetchNewsAtUrl(gazetaUrl) { (news, error) in
                    if let gazetaNews = news {
                        self?.gazetaNews = gazetaNews
                    }
                    if let error = error {
                        self?.error = error
                    }
                    dispatchGroup.leave()
                }
            }
            DispatchQueue.global().async(group: dispatchGroup, execute: gazetaWorkItem)
        }
        
        dispatchGroup.notify(queue: .global()) { [weak self] in
            guard let self = self else { return }
            if let news = self.feedNews {
                completion(news, nil)
            } else {
                completion(nil, self.error)
                print("Bad connection!")
            }
        }
    }
}
