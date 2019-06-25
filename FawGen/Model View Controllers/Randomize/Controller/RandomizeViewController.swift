//
//  RandomizeViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class RandomizeViewController: UITableViewController {
    
    public enum LetsGoType: String {
        case simple
        case assist
    }
    
    
    // The back button 
    
    /// Represents the vertical displacement height when a child view
    /// controller is presented by the Parent. This height takes into
    /// consideration the SafeArea Bottom height (34px) find in all
    /// current and available iPhone X models
    public var larkPresentHeight = 500 + UIDevice().safeAreaBottomHeight()
    fileprivate var dataSource = DataSource()
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    public var keyboardFrame = CGRect()
    public let horizontalSpaceKeyboardLowerSimpleAssistView: CGFloat = 10
    public let halfHeightSimpleAssistView: CGFloat = 135
    public let heightButtonsToLetsGo: CGFloat = 60
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarItems()
        setupTableView()
        //tableView.tableFooterView.si
        // Add observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
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
        
        // Remove Observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
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
            //tableView.isScrollEnabled = true
            print("DataSource is not empty")
            // Set => Reset and AnotherSet FooterView
            let viewBounds = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 80)
            let resetAnotherSetView = UIView(frame: viewBounds)
            resetAnotherSetView.backgroundColor = .red
            tableView.tableFooterView = resetAnotherSetView
        } else {
            //tableView.isScrollEnabled = false
            let simpleAssistView = SimpleAssistView(frame: tableView.bounds)
            simpleAssistView.simpleAssistDelegate = self
            tableView.tableFooterView = simpleAssistView
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


// Getting info from the SimpleAssistView
extension RandomizeViewController: SimpleAssistDelegate {
    
    func transferHand(_ type: String) {
        print("[TRANSFER HAND] from -> \(type)")
    }
    
    func querySimpleModel() {
        print("queryModelSimply")
        letsGoQuery(.simple)
    }
    
    func queryAssistedModel(by keywords: String) {
        print("queryModelAssisted, Keywords: \(keywords)")
        letsGoQuery(.assist, with: keywords)
    }
    
    private func letsGoQuery(_ type: LetsGoType, with keywords: String = String()){
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Get the fakeWords from the Model
        switch type {
        case .simple:
            print("Get X random words from model")
        case .assist:
            print("With KEYWORDS, get X random words from model")
        }
        
        // Variable to be replaces by words from model
        let newItems = dataSource.getRandomItems(count: 10)
        
        tableView.beginUpdates()
        let rowsCount = tableView.numberOfRows(inSection: 0)
        let indexPaths = (0..<rowsCount).map { IndexPath(row: $0, section: 0)}
        tableView.deleteRows(at: indexPaths, with: .automatic)
        dataSource.items.append(contentsOf: newItems)
        var indexPathsNew = [IndexPath]()
        for idx in 0..<dataSource.items.count {
            let path = IndexPath(row: idx, section: 0)
            indexPathsNew.append(path)
        }
        tableView.insertRows(at: indexPathsNew, with: .automatic)
        tableView.endUpdates()

        simpleAssistUI()
    }
    
    
    
}
