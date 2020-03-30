//
//  NewsModel.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 28/10/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import Foundation

struct NewsModel: Hashable, Equatable {
    
    var isViewed = false
    
    var newsResource: String = ""
    var newsLink: String = ""
    var newsTitle: String = ""
    var newsDescription: String = ""
    var imageURL: String = ""
    var dateOfCreation: String = ""
    var category: String = ""
    
    init(newsResource: String, newsLink: String, newsTitle: String, newsDescription: String, dateOfCreation: String, imageURL: String, category: String) {
        
        self.newsResource = newsResource
        self.newsLink = newsLink
        self.newsTitle = newsTitle
        self.newsDescription = newsDescription
        self.dateOfCreation = dateOfCreation
        self.imageURL = imageURL
        self.category = category
    }
}
