//
//  RandomizeVCExtension.swift
//  FawGen
//
//  Created by Erick Olibo on 14/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

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
            printConsole("[A-SADisplacement] FooterView Bounds: \(footer) - Displacement: \(displacement) - HeightBelow: \(heightBelow)")
            return displacement
        case let height where height < heightBelow:
            printConsole("[B-SADisplacement] FooterView Bounds: \(footer) - Displacement: \(displacement) - HeightBelow: \(heightBelow)")
            return heightBelow - height + displacement
        case let height where height > heightBelow:
            printConsole("[C-SADisplacement] FooterView Bounds: \(footer) - Displacement: \(displacement) - HeightBelow: \(heightBelow)")
            return height - heightBelow + displacement
        default:
            break
        }
        printConsole("[D-SADisplacement] FooterView Bounds: \(footer) - Displacement: \(displacement) - HeightBelow: \(heightBelow)")
        return displacement
    }
    
}




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
