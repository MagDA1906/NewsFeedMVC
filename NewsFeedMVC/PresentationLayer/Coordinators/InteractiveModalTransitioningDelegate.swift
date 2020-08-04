//
//  InteractiveModalTransitioningDelegate.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 16/02/2020.
//  Copyright © 2020 Денис Магильницкий. All rights reserved.
//

import Foundation
import UIKit

final class InteractiveModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var interactiveDismiss = true
    var transition = FadePresentAnimationController()
    
    init(from presented: UIViewController, to presenting: UIViewController) {
        super.init()
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        transition.originFrame = presenting.view.frame
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
        
    }
}
