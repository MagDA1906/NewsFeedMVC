//
//  ContainerViewController.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 23/12/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit

protocol ContainerViewControllerDelegate: class {
    func shouldMoveBackController()
    func shouldReloadData(using category: MenuModel)
}

class ContainerViewController: UIViewController, ContainerViewControllerDelegate {
    
    // MARK: - Private Variables
    
    private var controller: UIViewController!
    private var menuController: UIViewController!
    private var blurEffectView: UIVisualEffectView!
    private var isMove = false
    private var categoryName = "Картина дня"
    private var isVertical = false
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationItem()
        addSettingsBarButton()
        addOptionsBarButton()
        configureNewsFeedController()
        
        
    }
    
    // MARK: - Delegating methods
    
    func shouldMoveBackController() {

        if let vc = self.menuController as? MenuViewController {
            self.categoryName = vc.categoryName
            self.navigationItem.title = vc.categoryName
        }
        toggleMenu()
    }
    
    func shouldReloadData(using category: MenuModel) {
        (controller as! NewsFeedScreenController).shouldReloadData(using: category)
    }
}

private extension ContainerViewController {
    
    func setBlurEffect(for containerView: UIView) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blurEffectView = blurEffectView
        return blurEffectView
    }
    
    // MARK: - Configure navigation item
    
    func configureNavigationItem() {
        
        navigationItem.hidesBackButton = true

        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = SourceColors.labelRedColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        

        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.title = categoryName
    }
    
    // MARK: - Create Settings Bar Button
    
    func addOptionsBarButton() {
        
        let optionsBarButton = UIBarButtonItem(image: SourceImages.menuIcon,
                                                style: .plain,
                                                target: self,
                                                action: #selector(actionOptionsButton))
        optionsBarButton.tintColor = .white
        navigationItem.setLeftBarButton(optionsBarButton, animated: true)
    }
    
    @objc func actionOptionsButton(sender: UIBarButtonItem) {
        
        toggleMenu()
    }
    
    // MARK: - Create
    
    func addSettingsBarButton() {
        
        let settingsBarButton = UIBarButtonItem(image: SourceImages.settingsIcon,
                                                style: .plain,
                                                target: self,
                                                action: #selector(actionSettingsButton))
        navigationItem.setRightBarButton(settingsBarButton, animated: true)
    }
    
    @objc func actionSettingsButton() {
        guard let vc = controller as? NewsFeedScreenController else { return }
        AppCoordinator.shared.goToSettingsScreenController(from: vc)
    }
    
    // MARK: - Initialized NewsFeedScreenController
    func configureNewsFeedController() {
        
        let newsFeedController = NewsFeedScreenController()
        controller = newsFeedController
        controller.view.frame = view.frame
        view.addSubview(controller.view)
        addChild(controller)
    }
    
    // MARK: - Initialized MenuViewController
    
    func configureMenuController() {
        
        if menuController == nil {
            menuController = MenuViewController()
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
        }
        
        guard let menuVC = menuController as? MenuViewController else {
            return
        }
        
        menuVC.delegate = self
    }
    
    func showMenuViewController(shouldMove: Bool) {
        if shouldMove {
            // show menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.controller.view.frame.origin.x = self.controller.view.frame.width - 140
                            (self.controller as! NewsFeedScreenController).view.addSubview(self.setBlurEffect(for: self.view))
            }) { [unowned self] (finished) in
                (self.controller as! NewsFeedScreenController).view.subviews.first?.isUserInteractionEnabled = false
                print("Show menu")
            }
        } else {
            // remove menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.controller.view.frame.origin.x = 0
                            self.blurEffectView.removeFromSuperview()
            }) { [unowned self] (finished) in
                (self.controller as! NewsFeedScreenController).view.subviews.first?.isUserInteractionEnabled = true
                print("Remove menu")
            }
        }
    }
    
    // MARK: - Create switched menu
    
    func toggleMenu() {
        configureMenuController()
        isMove = !isMove
        showMenuViewController(shouldMove: isMove)
    }
}
