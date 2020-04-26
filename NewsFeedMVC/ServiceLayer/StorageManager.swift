//
//  StorageManager.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 04/04/2020.
//  Copyright © 2020 Денис Магильницкий. All rights reserved.
//

import Foundation

private enum DateError: String {
    case dateDecodingError = "Date decoding failed"
}

protocol StorageManagerProtocol {
    
    // save request data to array by category
    func save(data: [NewsModel], by category: MenuModel)
    // get saved data by index path
    func getModel(by indexPath: IndexPath) -> NewsModel
    // get number of elements
    func getNumberOfElements() -> Int
    // set news property isViewed to true
    func setModelToViewedState(by indexPath: IndexPath)
    // remove all models
    func removeAll()
}

class StorageManager: StorageManagerProtocol {
    
    static let shared = StorageManager()
    
    init() {}
    
    var models = [NewsModel]()
    
    func save(data: [NewsModel], by category: MenuModel) {
        // prepare before save
        models.removeAll()
        var sortedModels = sortByDate(data)
        
        for index in sortedModels.indices {
            sortedModels[index].newsResource.getCharBeforeSpace()
            sortedModels[index].newsDescription.replacingNewlineCharWithSpace()
            sortedModels[index].newsDescription.replacingDoubleSpace()
        }
        // save models by category
        if category == .AllNews {
            models = sortedModels
        } else {
            for model in sortedModels {
                let categoryFromModel = model.category
                if categoryFromModel == category.description {
                    models.append(model)
                }
            }
        }
    }
        
    func getModel(by indexPath: IndexPath) -> NewsModel {
        return models[indexPath.row]
    }
    
    func getNumberOfElements() -> Int {
        return models.count
    }
    
    func setModelToViewedState(by indexPath: IndexPath) {
        models[indexPath.row].isViewed = true
    }
    
    func removeAll() {
        models.removeAll()
    }
    
    deinit {
        print("StorageManager class is deinit!")
    }
}

private extension StorageManager {
    // sort models by date
    func sortByDate(_ models: [NewsModel]) -> [NewsModel] {

        let sortedModelsByDate = models.sorted(by: { (m1, m2) -> Bool in
            m1.date.compare(m2.date) == .orderedDescending
        })
        return sortedModelsByDate
    }
}

