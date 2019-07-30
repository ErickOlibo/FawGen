//
//  RandomizeViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class RandomizeViewController: UITableViewController {
    public enum ObserverState {
        case add
        case remove
    }
    
    public enum LetsGoType: String {
        case simple
        case assist
    }
    
    public var isDisplacedUp: Bool = false
    public let reachability = Reachability()
    
    /// Represents the vertical displacement height when a child view
    /// controller is presented by the Parent. This height takes into
    /// consideration the SafeArea Bottom height (34px) find in all
    /// current and available iPhone X models
    public var larkPresentHeight = 300 + UIDevice().safeAreaBottomHeight()
    public var dataSource = DataSource()
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    public var keyboardFrame = CGRect()
    public let horizontalSpaceKeyboardLowerSimpleAssistView: CGFloat = 10
    public let halfHeightSimpleAssistView: CGFloat = 135
    public let heightButtonsToLetsGo: CGFloat = 60
    public var alreadyFakewords = Set<String>() {
        didSet {
            printConsole("ALREADY GENERATED: \(alreadyFakewords.count)")
        }
    }
    
    public var fontNamesList: [String] {
        return FontsLister().getAllFontNames()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        setupTableView()
        dataSource.delegate = self
        // Print Fonts
        //FontsLister().printListToConsole()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //printConsole("ViewWillAppear in [RandomizeViewController]")
        simpleAssistOrNewSetHomeUI()
        keyboardNotificationHandler(.add)
        applicationNotificationHandler(.add)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //printConsole("viewWillDisappear in [RandomizeViewController]")
        if let subViews = tableView.tableFooterView?.subviews {
            for view in subViews {
                view.removeFromSuperview()
            }
        }
        keyboardNotificationHandler(.remove)
        applicationNotificationHandler(.remove)
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




