//
//  UIViewExtension.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 10/12/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit

extension UIView {
    
    func superView() -> UILabel? {
        
        if self is UILabel {
            return self as? UILabel
        }
        
        if !(self.superview != nil) {
            return nil
        }
        
        return self.superview?.superView()
    }
}
