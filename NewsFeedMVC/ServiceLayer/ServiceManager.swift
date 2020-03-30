//
//  ServiceManager.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 08/11/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import Foundation
import UIKit

protocol ServiceManagerProtocol {
    
    var models: [NewsModel] { get }
    var modelsFromCategory: [NewsModel] { get }
    var imageCache: NSCache<NSString, UIImage> { get }
    
    func store(_ models: [NewsModel])
    func getModelAtIndex(_ index: Int) -> NewsModel
    func replaceModel(_ model: NewsModel, at index: Int)
    func storeModelsBy(_ category: MenuModel)
}

class ServiceManager: ServiceManagerProtocol {
    
    var models = [NewsModel]()
    var modelsFromCategory = [NewsModel]()
    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Save fetched data from URL request
    
    func store(_ models: [NewsModel]) {
        self.models = sortModelsByDate(models)
        modelsFromCategory = self.models
    }
    
    // MARK: - Return model at index
    
    func getModelAtIndex(_ index: Int) -> NewsModel {
        return modelsFromCategory[index]
    }
    
    // MARK: - Update model if needed
    
    func replaceModel(_ model: NewsModel, at index: Int) {
        let originModel = modelsFromCategory[index]
        
        modelsFromCategory[index] = model
        for ind in models.indices {
            if models[ind] == originModel {
                models[ind] = model
            }
        }
    }
    
    // MARK: - Get sorted array models by category
    
    func storeModelsBy(_ category: MenuModel){
        modelsFromCategory.removeAll()
        if category == .AllNews {
            modelsFromCategory = models
        } else {
            for model in models {
                let categoryFromModel = getCorrectString(model)
                if categoryFromModel == category.description {
                    modelsFromCategory.append(model)
                }
            }
        }
    }
}

private extension ServiceManager {
    
    // MARK: - Sort data by date creation
    
    func sortModelsByDate(_ models: [NewsModel]) -> [NewsModel] {
        
        var sortedModelsByDate = [NewsModel]()
        var modelDict = [Date:NewsModel]()
        var dates = [Date]()
        var sortedDates = [Date]()
        
        for model in models {
            
            let date = getDateFromModel(model)
            
            modelDict[date] = model
            dates.append(date)
        }
        
        sortedDates = dates.sorted(by: { $0.compare($1) == .orderedDescending })
        
        for date in sortedDates {
            
            sortedModelsByDate.append(modelDict[date]!)
        }
        
        return sortedModelsByDate
    }
    
    // MARK: - Get date with format: "EEE, dd MMM yyyy HH:mm:ss ZZ"
    
    func getDateFromModel(_ news: NewsModel) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZ\n "
        
        let dateString = news.dateOfCreation
        let dateComponents = dateString.components(separatedBy: "\n")
        
        if dateComponents.first != nil {
            if let date = dateFormatter.date(from: dateComponents.first!) {
                return date
            }
        }
        
        return Date()
    }
    
    func getCorrectString(_ news: NewsModel) -> String? {
        let stringComponents = news.category.components(separatedBy: "\n")
        if stringComponents.first != nil {
            return stringComponents.first!
        } else {
            return nil
        }
    }
}
