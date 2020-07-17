//
//  RealmModel.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 16.07.2020.
//  Copyright © 2020 Денис Магильницкий. All rights reserved.
//

import Foundation
import RealmSwift

class RealmModel: Object {
    
    @objc dynamic var isViewed = false
    @objc dynamic var newsResource: String = ""
    @objc dynamic var newsLink: String = ""
    @objc dynamic var newsTitle: String = ""
    @objc dynamic var newsDescription: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var dateOfCreation = ""
}
