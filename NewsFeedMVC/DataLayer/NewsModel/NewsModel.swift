//
//  NewsModel.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 28/10/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import Foundation

private enum ReturnType {
    case returnString
    case returnDate
}

struct NewsModel: Hashable {
    
    var isViewed = false
    
    var newsResource: String = ""
    var newsLink: String = ""
    var newsTitle: String = ""
    var newsDescription: String = ""
    var imageURL: String = ""
    var category: String = ""
    var dateOfCreation: String = ""
    // use formattedDate isntead dateOfCreating
    var formattedDate: String {
        return getFormattedDate(description: .returnString) ?? "Date undefined"
    }
    var date: Date {
        return getFormattedDate(description: .returnDate) ?? Date()
    }
    
    init(newsResource: String, newsLink: String, newsTitle: String, newsDescription: String, dateOfCreation: String, imageURL: String, category: String) {
        
        self.newsResource = newsResource
        self.newsLink = newsLink
        self.newsTitle = newsTitle
        self.newsDescription = newsDescription
        self.dateOfCreation = dateOfCreation
        self.imageURL = imageURL
        self.category = category
    }
    
    init() {}
    
}

extension NewsModel: Equatable {
    
    static func == (lhs: NewsModel, rhs: NewsModel) -> Bool {
        return lhs.newsResource == rhs.newsResource &&
            lhs.newsLink == rhs.newsLink &&
            lhs.newsTitle == rhs.newsTitle &&
            lhs.newsDescription == rhs.newsDescription &&
            lhs.dateOfCreation == rhs.dateOfCreation &&
            lhs.imageURL == rhs.imageURL &&
            lhs.category == rhs.category
    }
}

private extension NewsModel {

    func getFormattedDate<T>(description: ReturnType) -> T? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss ZZ\n "
        
        let dateString = dateOfCreation
        let dateComponents = dateString.components(separatedBy: "\n")
        
        if (dateComponents.first != nil) {
            if let date = dateFormatter.date(from: dateComponents.first!) {
                dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
                let formatedDateString = dateFormatter.string(from: date)
                switch description {
                case .returnDate:
                    return date as? T
                case .returnString:
                    return formatedDateString as? T
                }
            }
        }
        return nil
    }
}
