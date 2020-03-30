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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        configureNavigationItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ContainerViewController is created!")
        
        addSettingsBarButton()
        configureNewsFeedController()
    }
    
    func shouldMoveBackController() {
        if let vc = self.controller as? NewsFeedScreenController {
            vc.dowmloadCounter = 0
            vc.updateTableView()
        }
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
        navigationController?.navigationBar.barTintColor = SourceColors.commonBackgroundColor
        navigationController?.navigationBar.isTranslucent = false
        
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
    
    func configureNewsFeedController() {
        let newsFeedController = NewsFeedScreenController()
        controller = newsFeedController
        view.addSubview(controller.view)
        addChildViewController(controller)
    }
    
    // MARK: - Initialized MenuViewController
    
    func configureMenuController() {
        if menuController == nil {
            menuController = MenuViewController()
            view.insertSubview(menuController.view, at: 0)
            addChildViewController(menuController)
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
        configureMenuController()
        isMove = !isMove
        showMenuViewController(shouldMove: isMove)
    }
}
