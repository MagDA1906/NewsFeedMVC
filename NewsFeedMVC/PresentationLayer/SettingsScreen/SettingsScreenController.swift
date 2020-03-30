//
//  SettingsScreenController.swift
//  NewsFeedMVC
//
//  Created by Денис Магильницкий on 23/12/2019.
//  Copyright © 2019 Денис Магильницкий. All rights reserved.
//

import UIKit

class SettingsScreenController: UIViewController {
    
    // MARK: - Private Properties
    
    private var tableView: UITableView!
    
    private let confirmButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.setTitle("Confirm", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name: "System", size: 20.0)
        button.contentMode = .scaleAspectFit
        button.clipsToBounds = true
        return button
    }()
    
    private let footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 50))
        view.backgroundColor = UIColor.clear
        return view
    }()
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        view.layer.masksToBounds = true
//        view.layer.cornerRadius = 0.5
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("SettingsScreenController is load")
        
        configureTableView()
        
    }
    
}

// MARK: - Private Functions

private extension SettingsScreenController {

    func configureTableView() {
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
//        tableView.dataSource = self
        
        // Register TableViewCells
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        tableView.backgroundColor = SourceColors.commonLightBlueColor
        tableView.contentInset = UIEdgeInsets.zero
        
        // tableView constraints
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        configureFooterView()
        
    }
    
    func configureFooterView() {
        footerView.addSubview(confirmButton)
        
        confirmButton.addTarget(self, action: #selector(actionConfirmButton), for: .touchUpInside)
        
        // confirmButton constraints
        confirmButton.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
        confirmButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
        tableView.tableFooterView = footerView
    }
    
    @objc func actionConfirmButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension SettingsScreenController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

//extension SettingsScreenController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    }
//}
