//
//  RandomizeVCExtension.swift
//  FawGen
//
//  Created by Erick Olibo on 14/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


// MARK: - Notification Handler
extension RandomizeViewController {
    
    /// Place to get notification for UIApplication Active state
    public func applicationNotificationHandler(_ state: ObserverState) {
        switch state {
        case .add:
            NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        case .remove:
            NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
    
    /// Place to remove or add keyboard notification handler
    public func keyboardNotificationHandler(_ state: ObserverState) {
        switch state {
        case .add:
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        case .remove:
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        }
    }
    
    @objc func applicationWillResignActive(_ notification : NSNotification) {
        if let simpleAssistView = tableView.tableFooterView as? SimpleAssistView {
            simpleAssistView.keywordsGrowningTextView.resignFirstResponder()
        }
        keyboardNotificationHandler(.remove)
    }
    
    @objc func applicationDidBecomeActive(_ notification : NSNotification) {
        keyboardNotificationHandler(.add)
    }
    
    
    /// Selects the right TableFooterView to present. Depending on the
    /// size of the DataSource Items count. If 0 then AssistHome, else
    /// NewSetHome
    public func simpleAssistOrNewSetHomeUI() {
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

// MARK: - TableView RowAt
extension RandomizeViewController {
    
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
    
}


// MARK: - Comforming to NewSetHomeDelegate
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


// MARK: - Conforming to SimpleAssistDelegate
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
    private func letsGoQuery(_ type: LetsGoType, with keywords: String = String()) {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        var results = [FakeWord]()
        // Get the fakeWords from the Model
        switch type {
        case .simple:
            // Get the New Items from the DataShource to Display
            // This is the random one
            guard let madeUpwords = toolBox.generateMadeUpWords() else { return }
            results = madeUpwords.map{ FakeWord($0) }
            printConsole("Get X random words from model")
        case .assist:
            // Get the new Items from the Keyboards and vector space from
            // Model
            printConsole("With KEYWORDS, get X random words from model")
        }
        
        let updResults = dataSource.updatedFakeWordsResults(results)
        // Variable to be replaces by words from model
        // Used to be 20
//        let size = fontNamesList.count
//        let newItems = getNewRandomItems(count: size)
        
        tableView.beginUpdates()
        let rowsCount = tableView.numberOfRows(inSection: 0)
        let indexPaths = (0..<rowsCount).map { IndexPath(row: $0, section: 0)}
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
        dataSource.items = updResults
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


// MARK: - Navigation Bar
extension RandomizeViewController {
    
    public func setupNavigationBarItems() {
        setupRemainingNavItems()
        setupRightNavItems()
        setupNewLeftNavItems()
    }

    private func setupNewLeftNavItems() {
        let checkerButton = UIButton(type: .system)
        checkerButton.translatesAutoresizingMaskIntoConstraints = false
        checkerButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        checkerButton.setImage(UIImage(named: "checker")?.withRenderingMode(.alwaysOriginal), for: .normal)
        checkerButton.addTarget(self, action: #selector(presentCheckerViewController), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: checkerButton)
        
    }
    
    /// Sets the navigation bar 3 right items as listed in letf-to-right order:
    /// Favorite, Filter, Favorites.
    private func setupRightNavItems() {
        let collection = [("Settings" , #selector(presentSettingsViewController)),
                          ("Filter" , #selector(presentFilterViewController)),
                          ("favorite" , #selector(presentSavedListViewController))]
        var barButtonItems = [UIBarButtonItem]()
        for (imageName, selector) in collection {
            let itemButton = UIButton(type: .system)
            itemButton.translatesAutoresizingMaskIntoConstraints = false
            itemButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            itemButton.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
            itemButton.addTarget(self, action: selector, for: .touchUpInside)
            let itemBarButton = UIBarButtonItem(customView: itemButton)
            barButtonItems.append(itemBarButton)
        }
        navigationItem.rightBarButtonItems = barButtonItems
    }
    
    /// sets the remainder items not set in the setupNavigationBarItems(),
    /// setupLeftNavItems(), and setupRightNavItems().
    private func setupRemainingNavItems() {
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - Navigation Bar Button Actions
    
    // Presents as Stork transition and ViewController
    @objc private func presentCheckerViewController() {
        let checkerVC: CheckerViewController = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(withIdentifier: "CheckerVC") as! CheckerViewController
        }()
        let transitionDelegate = SPStorkTransitioningDelegate()
        checkerVC.transitioningDelegate = transitionDelegate
        checkerVC.modalPresentationStyle = .custom
        checkerVC.modalPresentationCapturesStatusBarAppearance = true
        self.present(checkerVC, animated: true, completion: nil)
    }
    
    
    /// Presents as push transition the settings view controller
    /// - Note: SettingsViewController is access via its StoryBoard identifier
    @objc private func presentSettingsViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = storyBoard.instantiateViewController(withIdentifier: "SettingsVC")
        self.navigationController?.pushViewController(settingsVC, animated: true)
        
    }
    
    /// Presents the Filter View Controller as Lark transition
    /// (slides up to reveal behind)
    /// - Note: FilterViewController is access via its StoryBoard identifier
    @objc private func presentFilterViewController() {
        let filterVC: FilterViewController = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(withIdentifier: "FilterVC") as! FilterViewController
        }()
        
        let transitionDelegate = SPLarkTransitioningDelegate()
        filterVC.transitioningDelegate = transitionDelegate
        filterVC.modalPresentationStyle = .custom
        filterVC.modalPresentationCapturesStatusBarAppearance = true
        self.presentAsLark(filterVC, height: larkPresentHeight, complection: nil)
        
    }
    
    
    /// Presents as push transition the FavoritesView controller
    /// - Warning: Missing implementation for FavoritesViewController
    @objc private func presentSavedListViewController() {
        printConsole("pushedSavedListButton")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let savedListVC = storyBoard.instantiateViewController(withIdentifier: "SavedListVC") as! SavedListViewController
        self.navigationController?.pushViewController(savedListVC, animated: true)
    }
    
    /// Presents as push transition the DetailsView Controller
    /// - Note: DetailsViewController is access via its StoryBoard identifier
    private func presentDetailsViewController(_ fakeWord: FakeWord) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = storyBoard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsViewController
        detailsVC.fakeWord = fakeWord
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    
}


// MARK: - Keyboard notifications
extension RandomizeViewController {
    /// Notifies when the keyboard is about to show in order the displace the view
    /// accordingly of the keyboard height
    @objc func keyboardWillShow(notification: NSNotification) {
        if let simpleAssistView = tableView.tableFooterView as? SimpleAssistView,
            simpleAssistView.keywordsGrowningTextView.isFirstResponder {
            //printConsole("In KEYBOARD WILL SHOW, Growing is First Responder")
            guard let userInfo = notification.userInfo else { return }
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            keyboardFrame = keyboardSize.cgRectValue
            printConsole("[keyboardWillShow] - About to Displace UP")
            if !isDisplacedUp {
                view.frame.origin.y -= SimpleAssistDisplacement()
                isDisplacedUp = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let simpleAssistView = tableView.tableFooterView as? SimpleAssistView,
            simpleAssistView.keywordsGrowningTextView.isFirstResponder {
            //printConsole("In KEYBOARD WILL HIDE, Growing is First Responder")
            printConsole("[keyboardWillHide] - About to Displace DOWN")
            if isDisplacedUp {
                view.frame.origin.y += SimpleAssistDisplacement()
                isDisplacedUp = false
            }
        }
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        printConsole("[keyboardDidHide] JUST HIDE!")
    }
    
    /// Displaces the SimpleAssistView in order to place it in respect of the
    /// newly displayed keyboard
    private func SimpleAssistDisplacement() -> CGFloat {
        printConsole("FooterView in SimpleAssistDisplacement")
        let displacement = 0.0 + (UIDevice().safeAreaBottomHeight() / 2)
        let keyboardHeight = keyboardFrame.height
        guard let footer = tableView.tableFooterView?.bounds else { return displacement }
        
        let heightBelow = (footer.height / 2) - halfHeightSimpleAssistView - 10.0
        switch  keyboardHeight {
        case let height where height == heightBelow:
            return displacement
        case let height where height < heightBelow:
            return heightBelow - height + displacement
        case let height where height > heightBelow:
            return height - heightBelow + displacement
        default:
            break
        }
        return displacement
    }
    
}


// MARK: - DataSource Delegate
extension RandomizeViewController: DataSourceDelegate {
    func didTapShowDetailsReport(fakeWord: FakeWord) {
        if reachability.networkStatus() == .unavailable {
            if let controller = reachability.internetConnectionAlertController() {
                present(controller, animated: true, completion: nil)
            }
        } else {
            presentDetailsViewController(fakeWord)
        }
    }

}
