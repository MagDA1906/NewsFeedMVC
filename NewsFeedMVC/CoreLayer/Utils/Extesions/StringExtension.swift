//
//  StringExtension.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 04/11/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import Foundation

extension String {
    
    mutating func getCharBeforeSpace() {
        let components = self.components(separatedBy: " ")
        if components.count > 0 {
            self = components.first!
        }
    }
}
