//
//  FadePresentAnimationController.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 01.07.2020.
//  Copyright © 2020 Денис Магильницкий. All rights reserved.
//

import UIKit

class FadePresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting = true
    var originFrame = CGRect.zero
    
    private let duration = 0.3
    private let offset: CGFloat = 0.9
    private var  blurView: UIView!
    private var blurEffectView: UIVisualEffectView!
    
    private var startPoint: CGPoint!
    private var finishPoint: CGPoint!
    
    private func setBlurEffect(for containerView: UIView) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        return blurEffectView
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let currentController = presenting ? transitionContext.viewController(forKey: .to)! : transitionContext.viewController(forKey: .from)!

        currentController.view.frame.size = CGSize(width: originFrame.size.width * 0.9, height: originFrame.size.height * 0.9)
        currentController.view.layer.cornerRadius = 20
        currentController.view.layer.masksToBounds = true
        currentController.view.center = CGPoint(x: originFrame.width / 2, y: originFrame.height / 2)
        
        // create start point of center for the current view controller
        let xStartPoint = originFrame.midX
        let yStartPoint = originFrame.midY - originFrame.height
        startPoint = CGPoint(x: xStartPoint, y: yStartPoint)
        
        currentController.view.center = startPoint
        
        // create finish point of center for the current view controller
        let xFinishPoint = originFrame.midX
        let yFinishPoint = originFrame.midY
        finishPoint = CGPoint(x: xFinishPoint, y: yFinishPoint)

        if presenting {
            blurView = UIView(frame: originFrame)
            blurView.addSubview(self.setBlurEffect(for: blurView))
        }

        containerView.addSubview(blurView)
        containerView.addSubview(currentController.view)

        if presenting {
            currentController.view.alpha = 0.0
            blurView.alpha = 0.0
            
            UIView.transition(with: currentController.view,
                              duration: duration,
                              options: .transitionCurlDown,
                              animations: {
                                currentController.view.center = self.finishPoint
                                currentController.view.alpha = 1.0
                                self.blurView.alpha = 1.0
            }) { _ in
                transitionContext.completeTransition(true)
            }
        } else {
            currentController.view.alpha = 1.0
            blurView.alpha = 1.0
            currentController.view.center = finishPoint
            
            UIView.transition(with: currentController.view,
                              duration: duration,
                              options: .curveLinear,
                              animations: {
                                currentController.view.center = self.startPoint
                                self.blurView.alpha = 0.0
                                currentController.view.alpha = 0.0
            }) { _ in
                self.blurView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }

    }
}
