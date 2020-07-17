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
    
    // MARK: - Public Properties
    
    var categoryName = ""
    
    // MARK: - Deleagate
    
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
    
    // MARK: - Configure TableView
    
    func configureTableView() {
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.reuseId)
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.backgroundColor = UIColor.darkGray
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 90, right: 0)
        
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
        customView.backgroundColor = UIColor.lightGray
        cell.selectedBackgroundView = customView
    }
    
    func checkSelectedCells() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
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
        categoryName = menuModel.description
        self.delegate?.shouldReloadData(using: menuModel)
        self.delegate?.shouldMoveBackController()
        
        //            if StorageManager.shared.models.isEmpty {
        //                NetStatus.shared.netStatusChangeHandler = { [unowned self] in
        //                    if NetStatus.shared.isMonitoring, NetStatus.shared.isConnected {
        //                        self.NFCdelegate?.fetchNews(using: menuModel, nil)
        //                    }
        //                }
        //            }
        
    }
}

// MARK: - UITableViewDataSource

extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuModel.House.rawValue + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return menuCellForIndexPath(indexPath)
    }
}
