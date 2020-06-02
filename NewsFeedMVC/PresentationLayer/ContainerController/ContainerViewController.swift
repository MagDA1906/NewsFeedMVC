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
}

class ContainerViewController: UIViewController, ContainerViewControllerDelegate {
    
    // MARK: - Private Variables
    
    private var controller: UIViewController!
    private var menuController: UIViewController!
    private var blurEffectView: UIVisualEffectView!
    private var isMove = false
    private var categoryName = "Картина дня"
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ContainerViewController is created!")
        
        configureNavigationItem()
        addSettingsBarButton()
        configureMenuController()
        configureNewsFeedController()
    }
    
    deinit {
        NetStatus.shared.stopMonitoring()
    }
    
    // MARK: - Delegate MenuController
    
    func shouldMoveBackController() {

        if let vc = self.menuController as? MenuViewController {
            self.categoryName = vc.categoryName
            self.navigationItem.title = vc.categoryName
        }
        toggleMenu()
    }
}

private extension ContainerViewController {
    
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
    
    func addSettingsBarButton() {
        
        let settingsBarButton = UIBarButtonItem(image: SourceImages.settingsIcon,
                                                style: .plain,
                                                target: self,
                                                action: #selector(actionSettingsButton))
        navigationItem.setLeftBarButton(settingsBarButton, animated: true)
    }
    
    @objc func actionSettingsButton() {
        toggleMenu()
    }
    
    // MARK: - Initialized NewsFeedScreenController
    // configure NewsFeedController with MenuViewController as a parameter
    func configureNewsFeedController() {
        
        guard let menuController = menuController as? MenuViewController else { return }
        let newsFeedController = NewsFeedScreenController(controller: menuController)
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
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.controller.view.frame.origin.x = self.controller.view.frame.width - 140
            }) { (finished) in
                print("Show menu")
            }
        } else {
            // remove menu
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                            self.controller.view.frame.origin.x = 0
            }) { (finished) in
                print("Remove menu")
            }
        }
    }
    
    // MARK: - Create switched menu
    
    func toggleMenu() {
        isMove = !isMove
        showMenuViewController(shouldMove: isMove)
    }
}
