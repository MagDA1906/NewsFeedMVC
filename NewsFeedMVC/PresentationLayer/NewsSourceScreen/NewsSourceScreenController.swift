//
//  NewsSourceScreenController.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 03/12/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit
import WebKit

class NewsSourceScreenController: UIViewController {
    
    // MARK: - Private Properties
    
    private var webView: WKWebView!
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Public Properties
    
    var resourceURL: String?
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationItem()
    }
    
    override func loadView() {

        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        sendRequest()
    }
}

private extension NewsSourceScreenController {
    
    func configureNavigationItem() {
        
        navigationItem.hidesBackButton = false
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = SourceColors.labelRedColor
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Source news"
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            
        }
    }
    
    private func setActivityIndicator() {
        
        // Configure Activity Indicator
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.color = SourceColors.commonBackgroundColor
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        webView.addSubview(activityIndicator)
        
        // Add constraints
        
        activityIndicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor).isActive = true
    }
    
    func sendRequest() {
        
        var modifiedString = ""
        
        guard let resourceURL = resourceURL else {
            return
        }
        
        if resourceURL.contains("\n  ") {
            modifiedString = resourceURL.replacingOccurrences(of: "\n  ", with: "")
        } else if resourceURL.contains("\n") {
            modifiedString = resourceURL.replacingOccurrences(of: "\n", with: "")
        }
        
        if let url = URL(string: modifiedString) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
}

extension NewsSourceScreenController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        setActivityIndicator()
        showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
}
