//
//  AppCoordinator.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 28/10/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit

final class AppCoordinator {
    
    private var detailsTransitioningDelegate: InteractiveModalTransitioningDelegate!
    
    static let shared = AppCoordinator()
    
    private init() {}
    
    private let rootViewController = StartScreenViewController()
    private let storageManager = StorageManager()
    
    func root(_ window: inout UIWindow?) {
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
    }
    
    func goToContainerController(from source: UIViewController) {
        
        let vc = ContainerViewController()
        source.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToNewsFeedScreen(from source: UIViewController) {
        
        let vc = NewsFeedScreenController()
        source.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToNewsSourceScreenController(from source: UIViewController, with indexPath: IndexPath) {
        
        let vc = NewsSourceScreenController()
        
        vc.resourceURL = StorageManager.shared.getModel(by: indexPath).newsLink
        StorageManager.shared.setModelToViewedState(by: indexPath)
        
        source.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToSettingsScreenController(from source: UIViewController) {
        
//        let vc = SettingsScreenController()
//        vc.title = "Settings"
//        vc.modalPresentationStyle = .custom
//        vc.modalTransitionStyle = .coverVertical
//        source.present(vc, animated: true, completion: nil)
        
        let vc = SettingsScreenController()
        detailsTransitioningDelegate = InteractiveModalTransitioningDelegate(from: source, to: vc)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = detailsTransitioningDelegate
        source.present(vc, animated: true, completion: nil)
    }
}
