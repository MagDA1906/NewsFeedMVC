//
//  InteractiveModalPresentationController.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 16/02/2020.
//  Copyright © 2020 Денис Магильницкий. All rights reserved.
//

import Foundation
import UIKit

final class InteractiveModalPresentationController: UIPresentationController {
    
    // MARK: - Private Properties
    
    private let presentedYOffset: CGFloat = 150
    private var direction: CGFloat = 0
    private var blurEffectView: UIVisualEffectView!
    
    private lazy var dimmingView: UIView! = {
        guard let container = containerView else { return nil }
        
        let view = UIView(frame: container.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTap(tap:)))
        )
        return view
    }()
    // MARK: - Init
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    // MARK: - Gesture Recognizer
    @objc func didTap(tap: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Adjusting the Size and Layout of the Presentation
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        
        return CGRect(x: 0, y: self.presentedYOffset, width: container.bounds.width, height: container.bounds.height - self.presentedYOffset)
    }
    // TODO: - Add constraints for container!!!
    override func presentationTransitionWillBegin() {
        
        // Add a custom dimming view behind the presented view controller's view
        // Use the transition coordinator to set up the animations
        guard let container = containerView,
            let coordinator = presentingViewController.transitionCoordinator else { return }
        
        // Fade in the dimming view during the transition.
        dimmingView.alpha = 0
        container.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)
        
        coordinator.animate(alongsideTransition: { [unowned self] context in
            self.dimmingView.alpha = 1
            self.presentingViewController.view.addSubview(self.setBlurEffect(for: container))
            self.presentedViewController.view.alpha = 0.7
            self.presentedViewController.view.layer.cornerRadius = 20
            self.presentedViewController.view.layer.masksToBounds = true
            }, completion: nil)
    }
    
    // MARK: - Tracking the Transition’s Start and End
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        
        coordinator.animate(alongsideTransition: { [unowned self] (context) -> Void in
            self.dimmingView.alpha = 0
            self.blurEffectView.removeFromSuperview()
            self.presentedViewController.view.alpha = 1
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    // MARK: - Supporting Methods
    
    private func setBlurEffect(for containerView: UIView) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        return blurEffectView
    }
}
