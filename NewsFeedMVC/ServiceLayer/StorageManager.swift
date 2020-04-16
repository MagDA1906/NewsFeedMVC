//
//  StorageManager.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 04/04/2020.
//  Copyright © 2020 Денис Магильницкий. All rights reserved.
//

import Foundation

//private enum ReturnType {
//    case returnString
//    case returnDate
//}

private enum DateError: String {
    case dateDecodingError = "Date decoding failed"
}

protocol StorageManagerProtocol {
    
    // save request data to array
    func save(data: [NewsModel])
    // get saved data by index path
    func getModel(by indexPath: IndexPath) -> NewsModel
    // get number of elements
    func getNumberOfElements() -> Int
}

class StorageManager: StorageManagerProtocol {
    
    var models = [NewsModel]()
    
    func save(data: [NewsModel]) {
        // prepare before save
        var sortedModels = sortByDate(data)
        
        for index in sortedModels.indices {
            sortedModels[index].newsResource.getCharBeforeSpace()
            sortedModels[index].newsDescription.replacingNewlineCharWithSpace()
            sortedModels[index].newsDescription.replacingDoubleSpace()
        }
        models = sortedModels
    }
    
    func getModel(by indexPath: IndexPath) -> NewsModel {
        return models[indexPath.row]
    }
    
    func getNumberOfElements() -> Int {
        return models.count
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
