//
//  RandomizeViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class RandomizeViewController: UITableViewController {
    private enum ObserverState {
        case add
        case remove
    }
    
    public enum LetsGoType: String {
        case simple
        case assist
    }
    
    /// Represents the vertical displacement height when a child view
    /// controller is presented by the Parent. This height takes into
    /// consideration the SafeArea Bottom height (34px) find in all
    /// current and available iPhone X models
    public var larkPresentHeight = 400 + UIDevice().safeAreaBottomHeight()
    fileprivate var dataSource = DataSource()
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
        printConsole("ViewWillAppear in [RandomizeViewController]")
        simpleAssistOrNewSetHomeUI()
        keyboardNotificationHandler(.add)
        tableView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        printConsole("viewWillDisappear in [RandomizeViewController]")
        if let subViews = tableView.tableFooterView?.subviews {
            for view in subViews {
                view.removeFromSuperview()
            }
        }
        keyboardNotificationHandler(.remove)
        
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
    
    /// Place to remove or add keyboard notification handler
    private func keyboardNotificationHandler(_ state: ObserverState) {
        
        switch state {
        case .add:
            // Add observers
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        case .remove:
            // Remove Observers
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
            
        }
    }
    
    /// Selects the right TableFooterView to present. Depending on the
    /// size of the DataSource Items count. If 0 then AssistHome, else
    /// NewSetHome
    private func simpleAssistOrNewSetHomeUI() {
        if dataSource.items.count > 0 {
            tableView.isScrollEnabled = true
            let viewBounds = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60)
            let newSetHomeView = NewSetHomeView(frame: viewBounds)
            newSetHomeView.newSetHomeDelegate = self
            tableView.tableFooterView = newSetHomeView
            
        } else {
            let simpleAssistView = SimpleAssistView(frame: tableView.bounds)
            simpleAssistView.simpleAssistDelegate = self
            tableView.tableFooterView = simpleAssistView
            tableView.isScrollEnabled = false
            printConsole("[FooterView Bounds] - \(tableView.tableFooterView!.bounds)")
        }
    }
}




extension RandomizeViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FakeWordCell
        
        cell.state = .opened
        dataSource.addOpenedIndexPath(indexPath)
        
        tableView.beginUpdates()
        cell.bottomView.alpha = 0
        UIView.animate(withDuration: 0.7) {
            cell.bottomView.alpha = 1
        }
        cell.queryDomainSocialChecker()
        
        tableView.endUpdates()

        
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
        cell.cancelQueryDomainSocialChecker()
        
        tableView.endUpdates()

    }
}


// Comforming to NewSetHomeDelegate
extension RandomizeViewController: NewSetHomeDelegate {
    func showSimpleAssist() {
        prepareForShowingSimpleAssist()
    }
    
    func queryNewSetFromSimpleModel() {
        letsGoQuery(.simple)
    }
    
    
    private func prepareForShowingSimpleAssist() {
        let newItems = dataSource.getEmptyItems()
        tableView.beginUpdates()
        let rowsCount = tableView.numberOfRows(inSection: 0)
        let indexPaths = (0..<rowsCount).map { IndexPath(row: $0, section: 0)}
        tableView.deleteRows(at: indexPaths, with: .automatic)
        dataSource.items = newItems
        tableView.endUpdates()
        simpleAssistOrNewSetHomeUI()
    }
    
    
}


// Conforming to SimpleAssistDelegate
extension RandomizeViewController: SimpleAssistDelegate {
    
    func querySimpleModel() {
        letsGoQuery(.simple)
    }
    
    func queryAssistedModel(by keywords: String) {
        letsGoQuery(.assist, with: keywords)
    }
    
    
    /// Queries the model after the user has pressed Let's Go button. Depending
    /// on the type (simple or assit) a different Model Engine will be queried
    /// - Parameters:
    ///     - type: between simple and assist or without keywords or with
    ///     - keywords: string entered by the user
    private func letsGoQuery(_ type: LetsGoType, with keywords: String = String()){
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Get the fakeWords from the Model
        switch type {
        case .simple:
            // Get the New Items from the DataShource to Display
            // This is the random one
            printConsole("Get X random words from model")
        case .assist:
            // Get the new Items from the Keyboards and vector space from
            // Model
            printConsole("With KEYWORDS, get X random words from model")
        }
        
        // Variable to be replaces by words from model
        // Used to be 20
        let size = fontNamesList.count
        let newItems = getNewRandomItems(count: size)
        
        tableView.beginUpdates()
        let rowsCount = tableView.numberOfRows(inSection: 0)
        let indexPaths = (0..<rowsCount).map { IndexPath(row: $0, section: 0)}
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
        dataSource.items = newItems
        dataSource.indexPaths = Set<IndexPath>()
        var indexPathsNew = [IndexPath]()
        for idx in 0..<dataSource.items.count {
            let path = IndexPath(row: idx, section: 0)
            indexPathsNew.append(path)
        }
        tableView.insertRows(at: indexPathsNew, with: .automatic)
        tableView.endUpdates()

        if let firstIndex = indexPathsNew.first {
            tableView.scrollToRow(at: firstIndex, at: .top, animated: true)
        }
        simpleAssistOrNewSetHomeUI()
    }
    
    /// Makes sure the words were not used before
    private func getNewRandomItems(count: Int) -> [FakeWord] {

        return dataSource.getFontsToFakeword()
        
    }
    
}
