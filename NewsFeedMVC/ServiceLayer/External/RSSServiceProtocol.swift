//
//  RSSServiceProtocol.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 29/10/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import Foundation

protocol RSSServiceProtocol {
    
//    func fetchNews(_ complition: @escaping ([NewsModel]) -> ())
    func fetchNews(_ complition: @escaping ([NewsModel]) -> ())
}
