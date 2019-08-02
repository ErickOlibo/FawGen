//
//  RVC+DataSourceDelegate.swift
//  FawGen
//
//  Created by Erick Olibo on 02/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


// MARK: - TableView RowAt
extension RandomizeViewController: DataSourceDelegate {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FakeWordCell
        cell.setDomainSocialViewsToNormal()
        cell.state = .opened
        dataSource.addOpenedIndexPath(indexPath)
        
        tableView.beginUpdates()
        cell.bottomView.alpha = 0
        UIView.animate(withDuration: 0.7) {
            cell.bottomView.alpha = 1
        }
        tableView.endUpdates()
        cell.queryDomainSocialChecker()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FakeWordCell
        cell.state = .closed
        dataSource.removeOpenedIndexPath(indexPath)
        
        tableView.beginUpdates()
        cell.bottomView.alpha = 1
        UIView.animate(withDuration: 0.7) {
            cell.bottomView.alpha = 0
        }
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        printConsole("WILL SELECT at row: \(indexPath.row)")
        if reachability.networkStatus() == .unavailable {
            if let controller = reachability.internetConnectionAlertController() {
                present(controller, animated: true, completion: nil)
            }
            return nil
        } else {
            return indexPath
        }
    }
    
    public func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200.0
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    public func didTapShowDetailsReport(fakeWord: FakeWord) {
        if reachability.networkStatus() == .unavailable {
            if let controller = reachability.internetConnectionAlertController() {
                present(controller, animated: true, completion: nil)
            }
        } else {
            presentDetailsViewController(fakeWord)
        }
    }
    
}
