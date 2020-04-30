//
//  ViewController.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 28/10/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit

protocol NewsFeedScreenControllerProtocol {
    var dowmloadCounter: Int { get set }
}

class NewsFeedScreenController: UIViewController, NewsFeedScreenControllerProtocol {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchbar: UISearchBar!
    
    private let rssService = RSSService()
    
    private enum State {
        
        case expanded
        case collapsed
        
        var change: State {
            switch self {
            case .expanded:
                return .collapsed
            case .collapsed:
                return .expanded
            }
        }
    }
    
    // MARK: - Public Properties
    
    var dowmloadCounter = 0
    
    // MARK: - Private Properties
    
    private var currentIndexPath: IndexPath?
    private var oldIndexPath: IndexPath?
    private var state: State = .collapsed
    private var numberOfNews = 10
    
    private let downloadButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(SourceImages.downloadImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        button.isHidden = true
        
        return button
    }()
    
    private let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NewsFeedScreenController is load")
        
//        startMonitoringNetStatus()
        fetchNews()
        addTapGestureRecognizer()
        configureTableView()
        configureSearchBar()
        
        
        
        
        if !NetStatus.shared.isMonitoring {
            NetStatus.shared.startMonitoring()
        }
        print(NetStatus.shared.isConnected ? "Connected" : "Not connected")
        
        NetStatus.shared.didStartMonitoringHandler = {
            print("didStartMonitoringHandler")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("NewsFeedScreenController reload table view!")
        tableView.reloadData()
    }
}

// MARK: - Public Functions

extension NewsFeedScreenController {
    
    // use in MenuViewController (delegate)
    func updateTableView() {
        
        tableView.reloadData()
        if !StorageManager.shared.models.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
}

// MARK: - Private Functions

private extension NewsFeedScreenController {
    
//    func startMonitoringNetStatus() {
//
//        if !NetStatus.shared.isMonitoring {
//            NetStatus.shared.startMonitoring()
//        }
//
//        print(NetStatus.shared.isConnected ? "Connected" : "Not connected")
//
//        if NetStatus.shared.isConnected {
//            fetchNews()
//        } else {
//            showAlert()
//        }
////        NetStatus.shared.didStartMonitoringHandler = { [unowned self] in
////            if NetStatus.shared.isConnected {
////                self.fetchNews()
////            } else {
////                self.showAlert()
////            }
////        }
//    }
    
    func fetchNews() {
        
        rssService.fetchNews { [weak self] (models) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if models.isEmpty {
                    self.showAlert()
                }
                StorageManager.shared.save(data: models, by: .AllNews)
                self.tableView.reloadData()
            }
        }
    }
    
    func addTapGestureRecognizer() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        let touch = sender.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: touch) else { return }
        
        if let cell = tableView.cellForRow(at: indexPath) as? ExtendedNewsTableViewCell {
            
            if sender.state == .ended {
                
                let frameInSuperView = cell.getViewForTap().convert(cell.getViewForTap().bounds, to: tableView)
                
                if frameInSuperView.contains(touch) {
                    tableView.allowsSelection = false
                    let tappedView = cell.getViewForTap()
                    UIView.animate(withDuration: 0.1, animations: {
                        tappedView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    }) { (finished) in
                        UIView.animate(withDuration: 0.1, animations: {
                            tappedView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        }, completion: { [weak self] (finished) in
                            guard let self = self else { return }
                            self.tableView.allowsSelection = true
                            AppCoordinator.shared.goToNewsSourceScreenController(from: self, with: indexPath)
                        })
                    }
                }
            }
        }
    }
    
    func configureTableView() {
        
        let defaultCellReuseID  = DefaultNewsTableViewCell.nibName
        let extendedCellReuseID = ExtendedNewsTableViewCell.nibName
        
        let defaultCellNib  = UINib(nibName: defaultCellReuseID, bundle: nil)
        let extendedCellNib = UINib(nibName: extendedCellReuseID, bundle: nil)
        
        tableView.register(defaultCellNib, forCellReuseIdentifier: defaultCellReuseID)
        tableView.register(extendedCellNib, forCellReuseIdentifier: extendedCellReuseID)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        tableView.delegate    = self
        tableView.dataSource  = self
        
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        
        configureFooterView()
        
    }
    
    // MARK: - Create DefaultNewsTableViewCell
    
    func defaultCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultNewsTableViewCell.nibName, for: indexPath)
        guard let defaultCell = cell as? DefaultNewsTableViewCell else {
            return cell
        }
        defaultCell.setupWithModel(StorageManager.shared.getModel(by: indexPath))
        return defaultCell
    }
    
    // MARK: - Create ExtendedNewsTableViewCell
    
    func extendedCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExtendedNewsTableViewCell.nibName, for: indexPath)
        guard let extendedCell = cell as? ExtendedNewsTableViewCell else {
            return cell
        }
        extendedCell.setupWithModel(StorageManager.shared.getModel(by: indexPath))
        return extendedCell
    }
    
    // MARK: - Configure FooterView
    
    func configureFooterView() {
        footerView.addSubview(downloadButton)
        downloadButton.addTarget(self, action: #selector(actionFooterButton), for: UIControl.Event.touchUpInside)

        // footerButton constraints
        downloadButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        downloadButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        tableView.tableFooterView = footerView
    }
    
    @objc func actionFooterButton(_ sender: UIButton) {
        print("Footer button is taped!")
        dowmloadCounter = dowmloadCounter + numberOfNews
        tableView.reloadData()
        aniamteDownloadButton(sender)
    }
    
    // animation FooterButton
    
    func aniamteDownloadButton(_ sender: UIButton) {
        let springAnimation = CASpringAnimation(keyPath: "transform.scale")
        springAnimation.fromValue = 1
        springAnimation.toValue = 2
        springAnimation.duration = 0.06
        springAnimation.repeatCount = 1
        springAnimation.autoreverses = true
        sender.layer.add(springAnimation, forKey: "transform.scale")
    }
    
    // MARK: - Cnfigure UISearchBar
    
    func configureSearchBar() {
        
        searchbar.barTintColor = SourceColors.labelRedColor
    }
    
    func showAlert() {

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // open settings screen
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }

        let alert = UIAlertController(title: "No internet connection",
                                      message: "Check your internet connection using Settings button, or press OK",
                                      preferredStyle: .alert)
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)

        self.present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension NewsFeedScreenController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        if state == .collapsed {
            
            if cell is DefaultNewsTableViewCell {
                tableView.beginUpdates()
                state = state.change
                tableView.reloadRows(at: [indexPath], with: .right)
                currentIndexPath = indexPath
                tableView.endUpdates()
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        } else {
            
            if cell is ExtendedNewsTableViewCell {
                tableView.beginUpdates()
                state = state.change
                tableView.reloadRows(at: [indexPath], with: .left)
                tableView.endUpdates()
                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            } else {
                
                tableView.beginUpdates()
                oldIndexPath = currentIndexPath
                currentIndexPath = indexPath
                tableView.reloadRows(at: [indexPath], with: .right)
                
                if let oldIndex = oldIndexPath {
                    tableView.reloadRows(at: [oldIndex], with: .left)
                }
                tableView.endUpdates()
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    // Hide or show DownloadButton
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (ServiceAPI.shared.getNews().count - dowmloadCounter) > numberOfNews  {
            downloadButton.isHidden = false
        } else {
            downloadButton.isHidden = true
        }
    }
}

// MARK: - UITableViewDataSource

extension NewsFeedScreenController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ServiceAPI.shared.getNews().prefix(numberOfNews + dowmloadCounter).count
        return StorageManager.shared.getNumberOfElements()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath == currentIndexPath {
            switch state {
            case .collapsed:
                return defaultCellForIndexPath(indexPath)
            case .expanded:
                return extendedCellForIndexPath(indexPath)
            }
        } else if indexPath == oldIndexPath {
            return defaultCellForIndexPath(indexPath)
        }
        
        return defaultCellForIndexPath(indexPath)
    }
}
