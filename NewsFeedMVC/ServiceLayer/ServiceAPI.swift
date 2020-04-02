//
//  ServiceAPI.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 07/11/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import Foundation
import UIKit

protocol ServiceAPIProtocol {
    
    func fetchNews(_ complition: @escaping (Bool) -> ())
    func getNewsAtIndexPath(_ indexPath: IndexPath) -> NewsModel
    func getNews() -> [NewsModel]
    func storeNews(by category: MenuModel)
    func updateNewsAt(_ indexPath: IndexPath, ifNews didViewed: Bool?)
}

class ServiceAPI: ServiceAPIProtocol {
    
    static let shared = ServiceAPI()
    
    init() {}
    
    private let service: RSSServiceProtocol = RSSService()
    private let manager: ServiceManagerProtocol = ServiceManager()
    
    func fetchNews(_ complition: @escaping (Bool) -> ()) {
        
        service.fetchNews { (news) in
            print(news)
            self.manager.store(news)
            
            complition(true)
        }
    }
    // TODO: - Add notification Error
    
    func getNewsAtIndexPath(_ indexPath: IndexPath) -> NewsModel {
        return manager.getModelAtIndex(indexPath.row)
    }
    
    func getNews() -> [NewsModel] {
        return manager.modelsFromCategory
    }
    
    func updateNewsAt(_ indexPath: IndexPath, ifNews didViewed: Bool?) {
        var model = manager.getModelAtIndex(indexPath.row)
        
        guard let viewed = didViewed else { return }
        model.isViewed = viewed
        manager.replaceModel(model, at: indexPath.row)
    }
    
    func storeNews(by category: MenuModel) {
        manager.storeModelsBy(category)
    }
}
