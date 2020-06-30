//
//  StorageManager.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 04/04/2020.
//  Copyright © 2020 Денис Магильницкий. All rights reserved.
//

import Foundation
import RealmSwift

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
    // filtering models by searching from SearchBar
    func filteringModels(by searchingString: String?, with category: MenuModel)
}

class StorageManager: StorageManagerProtocol {
    
    static let shared = StorageManager()
    
    init() {}
    
    var models = [NewsModel]()
    var currentModels = [NewsModel]()
    
    func save(data: [NewsModel], by category: MenuModel) {
        // prepare before save
        models.removeAll()
        
        var sortedModels = sortByDate(data)
        
        for index in sortedModels.indices {
            sortedModels[index].newsResource.getCharBeforeSpace()
            sortedModels[index].newsDescription.replacingNewlineCharWithSpace()
            sortedModels[index].newsDescription.replacingDoubleSpace()
        }
        
        models = sortedModels
        
        // save models by category
        if category == .AllNews {
            currentModels = models
        } else {
            for model in sortedModels {
                let categoryFromModel = model.category
                if categoryFromModel == category.description {
                    currentModels.append(model)
                }
            }
        }
    }
        
    func getModel(by indexPath: IndexPath) -> NewsModel {
        return currentModels[indexPath.row]
    }
    
    func getNumberOfElements() -> Int {
        return currentModels.count
    }
    
    func setModelToViewedState(by indexPath: IndexPath) {
        currentModels[indexPath.row].isViewed = true
        for index in models.indices {
            print("Model = \(models[index])")
            print("Current = \(currentModels[indexPath.row])")
            if models[index] == currentModels[indexPath.row] {
                models[index].isViewed = true
                
                let key = models[index].newsLink
                let predicate = NSPredicate(format: "newsLink BEGINSWITH [c]%@", key)
                let realm = try! Realm()
                try! realm.write {
                    realm.objects(RealmModel.self).filter(predicate).first?.isViewed = true
                }
            }
        }
    }
    
    func removeAll() {
        models.removeAll()
        currentModels = models
    }
    
    func filteringModels(by searchingString: String?, with category: MenuModel) {
        
        var filteringArray = [NewsModel]()
        
        if category == .AllNews {
            currentModels = models
        } else {
            currentModels.removeAll()
            for model in models {
                let categoryFromModel = model.category
                if categoryFromModel == category.description {
                    currentModels.append(model)
                }
            }
        }
        
        if searchingString != nil {
            for model in currentModels {
                if model.newsTitle.localizedCaseInsensitiveContains(searchingString!) || model.newsDescription.localizedCaseInsensitiveContains(searchingString!) {
                    filteringArray.append(model)
                }
            }
            currentModels = filteringArray
        }
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

