//
//  RandomizeViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class RandomizeViewController: UITableViewController {
    
    /// Represents the vertical displacement height when a child view
    /// controller is presented by the Parent. This height takes into
    /// consideration the SafeArea Bottom height (34px) find in all
    /// current and available iPhone X models
    public var larkPresentHeight = 500 + UIDevice().safeAreaBottomHeight()
    fileprivate var dataSource = DataSource()
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        setupTableView()
    }
    
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 360.0
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
//


}


extension RandomizeViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RandomizeCell
        
        cell.state = .expanded
        dataSource.addExpandedIndexPath(indexPath)
        
        DispatchQueue.main.async {
            tableView.beginUpdates()
            UIView.animate(withDuration: 0.7) {
                cell.detailsView.alpha = 1
            }
            tableView.endUpdates()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! RandomizeCell
        
        cell.state = .collapsed
        dataSource.removeExpandedIndexPath(indexPath)
        
        DispatchQueue.main.async {
            tableView.beginUpdates()
            UIView.animate(withDuration: 0.7) {
                cell.detailsView.alpha = 0
            }
            tableView.endUpdates()
        }
    }
}


