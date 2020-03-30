//
//  MenuViewController.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 23/12/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var tableView: UITableView!
    private var timer: Timer?
    
    // MARK: - Public Properties
    
    var categoryName = ""
    
    weak var delegate: ContainerViewControllerDelegate?
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        checkSelectedCells()
    }

}
// MARK: - Configure MenuViewController

private extension MenuViewController {
    
    func configureTableView() {
        
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.reuseId)
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.backgroundColor = SourceColors.commonLightBlueColor
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 90, 0)
        
        // tableView constraints
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
    }
    
    // MARK: - Create MenuTableViewCell
    
    func menuCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.reuseId, for: indexPath)
        guard let menuCell = cell as? MenuTableViewCell else {
            return cell
        }
        
        updateSelectedCellBackgroundView(menuCell)
        
        let menuModel = MenuModel(rawValue: indexPath.row)
        menuCell.iconImageView.image = menuModel?.image
        menuCell.categoryLabel.text = menuModel?.description
        
        return menuCell
    }
    
    // MARK: - Methods for supporting cell selection
    
    func updateSelectedCellBackgroundView(_ cell: UITableViewCell) {
        let customView = UIView()
        customView.backgroundColor = SourceColors.commonBackgroundColor
        cell.selectedBackgroundView = customView
    }
    
    func checkSelectedCells() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    // MARK: - Delay before menu controller will collapse
    
    func startTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(collapseMenu), userInfo: nil, repeats: false)
        }
    }
    
    @objc func collapseMenu() {
        delegate?.shouldMoveBackController()
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - UITableViewDelegate

extension MenuViewController: UITableViewDelegate {
    // TODO: - After back from SettingsController - selection on Settings
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let cell = tableView.cellForRow(at: indexPath) as? MenuTableViewCell else {
            return
        }
        updateSelectedCellBackgroundView(cell)
        
        guard let menuModel = MenuModel(rawValue: indexPath.row) else {
            return
        }
        if menuModel == MenuModel.Settings {
            tableView.deselectRow(at: indexPath, animated: true)
            print("Settings is tapped")
            AppCoordinator.shared.goToSettingsScreenController(from: self)
        } else {
            ServiceAPI.shared.storeNews(by: menuModel)
            categoryName = menuModel.description
        }
        startTimer()
        
    }
}

// MARK: - UITableViewDataSource

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuModel.Settings.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return menuCellForIndexPath(indexPath)
    }
}
