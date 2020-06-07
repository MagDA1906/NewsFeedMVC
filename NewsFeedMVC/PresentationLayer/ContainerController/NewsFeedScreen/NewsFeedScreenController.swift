//
//  ViewController.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 28/10/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit

protocol NewsFeedScreenControllerProtocol: class {

    func shouldReloadData(using selectedCategory: MenuModel)
    
}

class NewsFeedScreenController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!

    
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
    
    // MARK: - Private Properties
    
    private var spinner: UIActivityIndicatorView!
    private var currentIndexPath: IndexPath?
    private var oldIndexPath: IndexPath?
    private var state: State = .collapsed
    private var newsCategory: MenuModel?
    private var timer: Timer?
    private var canTransitionToLarge = false
    private var searchBar: UISearchBar!
    
    private var category: MenuModel? {
        get {
            return newsCategory
        }
        set {
            newsCategory = newValue
        }
    }
    
    // MARK: - Closures
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var animator: UIViewPropertyAnimator = {
        return UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut, animations: nil)
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = SourceColors.labelRedColor
        
        addTapGestureRecognizer()
        configureSearchBar()
        configureTableView()
        configureSpinner()
        checkConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("NewsFeedScreenController reload table view!")
        
        startMonitoringNetStatus()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.tableHeaderView = searchBar
        searchBar.isHidden = false
    }
}

// MARK: - Private Functions

private extension NewsFeedScreenController {
    
    // MARK: - Start monitoring internet connection
    
    func startMonitoringNetStatus() {

        if !NetStatus.shared.isMonitoring {
            NetStatus.shared.startMonitoring()
        }
    }

    // If app launched without internet connection, we should monitoring connection and if connection is successed reload data
    func checkConnection() {
        // will launched one time
        spinner.startAnimating()
        NetStatus.shared.netStatusChangeHandler = { [unowned self] in
            if StorageManager.shared.models.isEmpty {
                if NetStatus.shared.isMonitoring, NetStatus.shared.isConnected {
                    self.fetchNews(using: .AllNews, nil)
                }
            }
        }
    }
    
    // TODO: If one of the cell is expanded it is should be colapsed
    func reloadTableView() {
        tableView.reloadData()
        if !StorageManager.shared.currentModels.isEmpty {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    // MARK: - Fetch news
    
    func fetchNews(using category: MenuModel, _ searchingString: String?) {
        
        rssService.fetchNews { [weak self] (models, error) in
            guard let self = self else { return }
            
            guard let models = models else { return }
            DispatchQueue.main.async {
                
                StorageManager.shared.save(data: models, by: category)
                
                self.reloadTableView()
                self.didStopSpinner()
            }
        }
    }
    
    // MARK: - Start and Stop Spinner
    
    func didStartSpinner() {
        
        spinner.startAnimating()
        self.view.bringSubviewToFront(spinner)
    }
    
    func didStopSpinner() {
        
        spinner.stopAnimating()
    }
    
    // MARK: - GestureRecognizer
    
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
    
    // Added refresh control function for update data
    @objc func refresh(sender: UIRefreshControl) {
        if NetStatus.shared.isConnected {
            let category = newsCategory ?? MenuModel.AllNews
            print("\(category.description)")
            fetchNews(using: category, nil)
        }
        sender.endRefreshing()
    }
    
    // MARK: - Configure TableView
    
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
        tableView.backgroundColor = SourceColors.labelRedColor
        
        tableView.refreshControl = refreshControl        
    }
    
    // MARK: - Configure Spinner
    
    func configureSpinner() {
        
        spinner = UIActivityIndicatorView()
        spinner.style = .whiteLarge
        spinner.color = UIColor.darkGray
        spinner.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(spinner)


        // spinner constraints
        spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
    }
    
    // MARK: - Cnfigure UISearchBar
    
    func configureSearchBar() {
        searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.size.width, height: 44.0))
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.barTintColor = SourceColors.labelRedColor
        searchBar.autocapitalizationType = .none
        searchBar.backgroundColor = .white
        searchBar.returnKeyType = .done
        searchBar.isHidden = false
        searchBar.tintColor = .white
        
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.backgroundColor = .white
            searchBar.searchTextField.textColor = .black
        }
    }
    
    // MARK: - Configure Timer

    func startTimerWith(_ searchingString: String) {
        
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { [unowned self] (timer) in
            
            let category = self.newsCategory ?? MenuModel.AllNews
            if searchingString == "" {
                StorageManager.shared.filteringModels(by: nil, with: category)
            } else {
                StorageManager.shared.filteringModels(by: searchingString, with: category)
            }
            self.reloadTableView()
            timer.invalidate()
        })
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
}

// MARK: - UITableViewDataSource

extension NewsFeedScreenController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

// MARK: - NewsFeedScreenControllerProtocol

extension NewsFeedScreenController: NewsFeedScreenControllerProtocol {
    
    func shouldReloadData(using selectedCategory: MenuModel) {
        category = selectedCategory
        StorageManager.shared.filteringModels(by: nil, with: selectedCategory)
        reloadTableView()
    }
}

// MARK: - UISearchBarDelegate

extension NewsFeedScreenController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        let category = newsCategory ?? MenuModel.AllNews
        StorageManager.shared.filteringModels(by: nil, with: category)
        reloadTableView()
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        print("SearchBarText = \(searchText)")
        startTimerWith(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
