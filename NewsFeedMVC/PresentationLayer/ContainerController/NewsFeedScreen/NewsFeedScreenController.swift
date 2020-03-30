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
    private var quantityNews = 10
    
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
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NewsFeedScreenController is load")
        
        fetchNews()
    
        addTapGestureRecognizer()
        
        configureTableView()
        configureSpinner()
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("NewsFeedScreenController reload table view!")
        tableView.reloadData()
    }
}

// MARK: - Public Functions

extension NewsFeedScreenController {
    
    func updateTableView() {
        tableView.reloadData()
    }
}

// MARK: - Private Functions

private extension NewsFeedScreenController {
    
    func fetchNews() {
        
        spinner.startAnimating()
        
        ServiceAPI.shared.fetchNews { (didFetch) in
            if didFetch {
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.spinner.stopAnimating()
                    self.spinner.hidesWhenStopped = true
                }
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
                    AppCoordinator.shared.goToNewsSourceScreenController(from: self, with: indexPath)
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
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 800
        
        tableView.delegate    = self
        tableView.dataSource  = self
        
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = SourceColors.commonBackgroundColor
        
        view.backgroundColor = SourceColors.commonBackgroundColor
        
        configureFooterView()
        
    }
    
    // MARK: - Create DefaultNewsTableViewCell
    
    func defaultCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultNewsTableViewCell.nibName, for: indexPath)
        guard let defaultCell = cell as? DefaultNewsTableViewCell else {
            return cell
        }
        defaultCell.setupWithModel(ServiceAPI.shared.getNewsAtIndexPath(indexPath))
        return defaultCell
    }
    
    // MARK: - Create ExtendedNewsTableViewCell
    
    func extendedCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExtendedNewsTableViewCell.nibName, for: indexPath)
        guard let extendedCell = cell as? ExtendedNewsTableViewCell else {
            return cell
        }
        extendedCell.setupWithModel(ServiceAPI.shared.getNewsAtIndexPath(indexPath))
        return extendedCell
    }
    
    // MARK: - Configure Spinner
    
    func configureSpinner() {
        spinner.activityIndicatorViewStyle = .whiteLarge
        spinner.color = SourceColors.commonBackgroundColor
    }
    
    // MARK: - Configure FooterView
    
    func configureFooterView() {
        footerView.addSubview(downloadButton)
        downloadButton.addTarget(self, action: #selector(actionFooterButton), for: UIControlEvents.touchUpInside)

        // footerButton constraints
        downloadButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        downloadButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        
        tableView.tableFooterView = footerView
    }
    
    @objc func actionFooterButton(_ sender: UIButton) {
        print("Footer button is taped!")
        dowmloadCounter = dowmloadCounter + quantityNews
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
            }
        } else {
            
            if cell is ExtendedNewsTableViewCell {
                
                tableView.beginUpdates()
                state = state.change
                tableView.reloadRows(at: [indexPath], with: .left)
                tableView.endUpdates()
                
            } else {
                
                tableView.beginUpdates()
                oldIndexPath = currentIndexPath
                currentIndexPath = indexPath
                tableView.reloadRows(at: [indexPath], with: .right)
                
                if let oldIndex = oldIndexPath {
                    tableView.reloadRows(at: [oldIndex], with: .left)
                }
                
                tableView.endUpdates()
            }
        }
        
    }
    
    // Hide or show DownloadButton
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (ServiceAPI.shared.getNews().count - dowmloadCounter) > quantityNews  {
            downloadButton.isHidden = false
        } else {
            downloadButton.isHidden = true
        }
    }
}

// MARK: - UITableViewDataSource

extension NewsFeedScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServiceAPI.shared.getNews().prefix(quantityNews + dowmloadCounter).count
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
