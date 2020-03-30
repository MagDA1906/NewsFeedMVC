//
//  WebImageService.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 02/12/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit

protocol WebImageServiceProtocol {
    var imageCache: NSCache<NSString,UIImage> { get }
    func downloadImage(_ key: NSString, complition: @escaping (_ image: UIImage?, _ error: Error?) -> ())
    func clearCache()
}

class WebImageService: WebImageServiceProtocol {
    
    var imageCache = NSCache<NSString, UIImage>()
    
    func clearCache() {
        imageCache.removeAllObjects()
    }
    
    func downloadImage(_ key: NSString, complition: @escaping (UIImage?, Error?) -> ()) {
        if let imageCache = imageCache.object(forKey: key) {
            complition(imageCache, nil)
        } else {
            WebImageService.downloadData(key) { (data, response, error) in
                if let error = error {
                    complition(nil, error)
                } else {
                    if let data = data, let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: key)
                        complition(image, nil)
                    } else {
                        complition(nil, NSError.generalParsingError(domain: String(key)))
                    }
                }
            }
        }
    }
    
    static func downloadData(_ key: NSString, complition: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) {
        guard let url = URL(string: String(key)) else { return }
        let urlSession = URLSession(configuration: .ephemeral).dataTask(with: URLRequest(url: url)) { (data, response, error) in
            complition(data, response, error)
        }
        urlSession.resume()
    }
}

extension NSError {
    static func generalParsingError(domain: String) -> Error {
        return NSError(domain: domain, code: 400, userInfo: [NSLocalizedDescriptionKey : NSLocalizedString("Error retrieving data", comment: "General Parsing Error Description")])
    }
}
