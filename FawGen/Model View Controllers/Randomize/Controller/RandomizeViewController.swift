//
//  RandomizeViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class RandomizeViewController: UITableViewController {

    // MARK: - Properties for Loading
    public var difference = CGFloat()
    public var start = Date()
    
//    public var model: Model!
//    public var toolBox: ToolBox!
//    public var kNN: KNearestNeighbors!
    
    public var persistent: Persistent!
    
    public var launchView: StartingEngine!
    public var launchBackground = UIView()
    let dataBaseManager = DefaultDB()
    
    // Holding Fakewords Result for the current round
    public var currentRoundItems = [FakeWord]()
    
    // MARK: - properties
    public let maxIterations = 3
    public enum ObserverState {
        case add, remove
    }
    
    public enum LetsGoType: String {
        case simple, assist
    }
    
    public var alreadyDisplayedFakeWordsTitles = Set<String>() {
        didSet {
            printConsole("Already Diplayed size: \(alreadyDisplayedFakeWordsTitles.count)")
        }
    }
    public var isRepeatSimpleSet: Bool = false
    public var isDisplacedUp: Bool = false
    public var currentKeywords = String()
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
    

    // MAKR: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        setupTableView()
        dataSource.delegate = self
        loadModelToMemory()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        simpleAssistOrNewSetHomeUI()
        keyboardNotificationHandler(.add)
        applicationNotificationHandler(.add)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let subViews = tableView.tableFooterView?.subviews {
            for view in subViews {
                view.removeFromSuperview()
            }
        }
        keyboardNotificationHandler(.remove)
        applicationNotificationHandler(.remove)
    }
    
    



}




