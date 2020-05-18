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
    
    @IBOutlet private weak var newsLabel: UILabel!
    @IBOutlet private weak var feedLabel: UILabel!
    @IBOutlet private weak var dotView: UIView!
    @IBOutlet private weak var backView: UIView!
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        animateNewsLabel()
        animateFeedLabel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        configureNewsLabel()
        configureFeedLabel()
        configureDotView()
    }
    
    
}

// MARK: - Private Functions

private extension StartScreenViewController {
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(transitionToViewController), userInfo: nil, repeats: false)
        }
    }
    
    @objc func transitionToViewController() {
        
        AppCoordinator.shared.goToContainerController(from: self)
        timer?.invalidate()
        timer = nil

    }
    
    func configureDotView() {
        
        dotView.backgroundColor = UIColor.black
        dotView.layer.cornerRadius = dotView.frame.width / 2
        
        dotView.alpha = 0.0
    }
    
    func configureNewsLabel() {
        
        if let font = UIFont(name: "Rockwell-Bold", size: 48), let text = newsLabel.text {
            let attributes = FontConfigurator.setAttributedTextWith(SourceColors.labelBorderColor, SourceColors.labelRedColor, -4.0, font)
            newsLabel.attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        }
        
        newsLabel.alpha = 0.0
        
        newsLabel.layer.shadowOpacity = 0.8
        newsLabel.layer.shadowOffset = CGSize(width: 2.0, height: -4.0)
        newsLabel.layer.shadowRadius = 2
        newsLabel.layer.shadowColor = UIColor.black.cgColor
        newsLabel.layer.masksToBounds = false
    }
    
    func configureFeedLabel() {
        
        if let font = UIFont(name: "Times-BoldItalic", size: 36), let text = feedLabel.text {
            let attributes = FontConfigurator.setAttributedTextWith(nil, SourceColors.labelPupleColor, nil, font)
            feedLabel.attributedText = NSMutableAttributedString(string: text, attributes: attributes)
        }
        
        feedLabel.alpha = 0.0
    }
    
    // Animations
    
    func animateNewsLabel() {

        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
            self.newsLabel.center = CGPoint(x: self.backView.center.x + self.backView.bounds.width / 2, y: self.backView.center.y)
            self.newsLabel.alpha = 1.0
        }) { (finished) in
            print("Animation finished!")
        }
    }
    
    func animateFeedLabel() {
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            self.feedLabel.center = CGPoint(x: self.backView.center.x - self.backView.bounds.width / 2, y: self.backView.center.y + 50)
            self.feedLabel.alpha = 1.0
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                self.feedLabel.alpha = 0.0
                self.newsLabel.alpha = 0.0
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.feedLabel.alpha = 1.0
                    self.newsLabel.alpha = 1.0
                    self.dotView.alpha = 1.0
                    
                    self.startTimer()
                })
            })
        }
    }
}

