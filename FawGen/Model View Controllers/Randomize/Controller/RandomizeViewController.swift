//
//  RandomizeViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class RandomizeViewController: UITableViewController {
    
    
    // The back button 
    
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
        //simpleAssistUI()
    }
    
    override func viewWillLayoutSubviews() {

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        simpleAssistUI()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // remove all views from theh footerView
        if let subViews = tableView.tableFooterView?.subviews {
            for view in subViews {
                view.removeFromSuperview()
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200.0
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //tableView.backgroundColor = FawGenColors.secondary.color
    }



}

extension RandomizeViewController {
    private func simpleAssistUI() {
        print("DataSource: \(dataSource.items.count)")
        if dataSource.items.count > 0 {
            print("DataSource is not empty")
            // Set => Reset and AnotherSet FooterView
            let viewBounds = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80)
            let resetAnotherSetView = UIView(frame: viewBounds)
            resetAnotherSetView.backgroundColor = .red
            tableView.tableFooterView = resetAnotherSetView
        } else {
            // Set => Simple Assist FooterView
//            let width = tableView.bounds.width
//            let height = tableView.bounds.height
//            let viewBounds = CGRect(x: 20, y: 500, width: 200, height: 200)
//            let simpleAssistView = UIView(frame: viewBounds)
//            simpleAssistView.backgroundColor = .orange
            tableView.isScrollEnabled = false
            tableView.tableFooterView = SimpleAssistView(frame: tableView.bounds)
            //print("W: \(width) - H: \(height)")
            print("ParentView: \(view.bounds)")
            print("TableView: \(tableView.bounds)")
            
        }
    }
    
    
    
}




extension RandomizeViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FakeWordCell
        print("didSelectRowAt")
        
        cell.state = .expanded
        dataSource.addExpandedIndexPath(indexPath)
        
        tableView.beginUpdates()
        cell.bottomView.alpha = 0
        UIView.animate(withDuration: 0.7) {
            cell.bottomView.alpha = 1
        }
        tableView.endUpdates()

        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FakeWordCell
        print("didDeselectRowAt")
        cell.state = .collapsed
        dataSource.removeExpandedIndexPath(indexPath)
        
        tableView.beginUpdates()
        cell.bottomView.alpha = 1
        UIView.animate(withDuration: 0.7) {
            cell.bottomView.alpha = 0
        }
        tableView.endUpdates()

    }
}


