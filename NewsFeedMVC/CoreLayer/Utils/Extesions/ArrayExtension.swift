//
//  ArrayExtension.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 02/04/2020.
//  Copyright © 2020 Денис Магильницкий. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
    
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
