//
//  SettingsScreenController.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 23/12/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit

class SettingsScreenController: UIViewController {
    
    // MARK: - Static properties
    
    private static let defaultTimeValue: Float = 35.0
    
    // MARK: - Closure
    
    var closure: ((Float)->Void)?
    
    private var interval: Float!
    
    // MARK: - Private Properties
    
    @IBOutlet private weak var refreshLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var shareButton: UIButton!
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var closeView: UIView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateAppearenceCloseView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SettingsScreenController is load")
        
        configureBackView()
        configureCloseView()
        
        configureShareButton()
        addTapGestureRecognizer()
        configureSlider()
        configureRefreshLabel()
    }
    
}

// MARK: - Private Functions

private extension SettingsScreenController {
    
    func configureRefreshLabel() {
        
        guard let slider = slider else { return }
        
        let curValue = Int(slider.value)
        refreshLabel.text = curValue.description
    }
    
    func configureBackView() {
        
        backView.backgroundColor = SourceColors.commonDarkRedColor
    }
    
    func configureSlider() {
        
        guard let savedValue = UserSettings.timeValue else { return }
        
        if savedValue == 0 {
            slider.setValue(SettingsScreenController.defaultTimeValue, animated: true)
        } else {
            slider.setValue(savedValue, animated: true)
        }
        
        slider.addTarget(self, action: #selector(actionSlider), for: .valueChanged)
    }
    
    @objc func actionSlider(sender: UISlider) {
        
        let step: Float = 5
        let currentValue = round(sender.value / step) * step
        
        let intVal = Int(currentValue)
        refreshLabel.text = (intVal.description)
        sender.value = Float(intVal)
        interval = sender.value
        
        UserSettings.timeValue = interval
        
        closure?(interval)
    }
    
    func configureShareButton() {
        
        shareButton.addTarget(self, action: #selector(actionShareButton), for: .touchUpInside)
    }
    
    @objc func actionShareButton(sender: UIButton) {
        
        print("ShareButton taped!")
        let message = "Привет! NewsFeed - это быстрое и простое приложение для просмотра новостной ленты! Скачать бесплатно можно пройдя по ссылке: www.appstore.com"
        let activityViewController = UIActivityViewController(activityItems: [message], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func configureCloseView() {
        
        closeView.backgroundColor = UIColor.clear
        closeView.layer.borderWidth = 2
        closeView.layer.borderColor = UIColor.white.cgColor
        closeView.layer.cornerRadius = closeView.bounds.width / 2
        closeView.alpha = 0.0
    }
    
    func animateAppearenceCloseView() {
        
        closeView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.closeView.transform = CGAffineTransform.identity
                        self.closeView.alpha = 1.0
        }) { (finished) in
            print("CloseView appearence animation finihed!")
        }
    }
    
    func animateDisappearanceCloseView() {
        
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseOut,
                       animations: {
                        self.closeView.transform = CGAffineTransform(scaleX: self.view.bounds.width / self.closeView.bounds.width, y: 0.1)
                        self.closeView.alpha = 0.0
        }) { (finished) in
            print("CloseView disappearence animation finihed!")
            if finished {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func addTapGestureRecognizer() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        let touch = sender.location(in: view)
        let closeViewFrameInSuperView = closeView.convert(closeView.bounds, to: view)
        
        if sender.state == .ended, closeViewFrameInSuperView.contains(touch) {
            animateDisappearanceCloseView()
        }
    }
}
