//
//  FontConfigurator.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 13/04/2020.
//  Copyright © 2020 Денис Магильницкий. All rights reserved.
//

import Foundation
import UIKit

protocol FontConfiguratorProtocol {
    
    static func setAttributedTextWith(_ strokeColor: UIColor?, _ foregroundColor: UIColor?, _ strokeWidth: Float?, _ font: UIFont) -> [NSAttributedString.Key: Any]
}

class FontConfigurator: FontConfiguratorProtocol {
    
    class func setAttributedTextWith(_ strokeColor: UIColor?, _ foregroundColor: UIColor?, _ strokeWidth: Float?, _ font: UIFont) -> [NSAttributedString.Key: Any] {
        
        var strokeTextAttributes: [NSAttributedString.Key: Any] = [:]
        
        if let strokeColor = strokeColor {
            strokeTextAttributes[NSAttributedString.Key.strokeColor] = strokeColor
        }
        
        if let foregroundColor = foregroundColor {
            strokeTextAttributes[NSAttributedString.Key.foregroundColor] = foregroundColor
        }
        
        if let strokeWidth = strokeWidth {
            strokeTextAttributes[NSAttributedString.Key.strokeWidth] = strokeWidth
        }
        
        strokeTextAttributes[NSAttributedString.Key.font] = font
        
        return strokeTextAttributes
    }
}
