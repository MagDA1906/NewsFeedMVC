//
//  StartScreenViewController.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 04/12/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit

class StartScreenViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var timer: Timer?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        configureSpinner()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.startAnimating()
        startTimer()
    }
    
    
}

// MARK: - Private Functions

private extension StartScreenViewController {
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(transitionToViewController), userInfo: nil, repeats: false)
        }
    }
    
    @objc func transitionToViewController() {
        AppCoordinator.shared.goToContainerController(from: self)
        timer?.invalidate()
        timer = nil
        spinner.stopAnimating()
    }
    
    func configureSpinner() {
        
        spinner.style = .whiteLarge
        spinner.color = UIColor.white
    }
}

