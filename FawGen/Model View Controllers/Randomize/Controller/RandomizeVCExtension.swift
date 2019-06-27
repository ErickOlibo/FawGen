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
        setupLeftNavItems()
        setupRightNavItems()
    }
    
    /// Sets up FawGen logo as a navigation bar left tappable item
    /// with a push present of a WebView to display
    /// www.fawgen.com website.
    private func setupLeftNavItems() {
        let logoButton = UIButton(type: .system)
        logoButton.setImage(UIImage(named: "logoNavBar")?.withRenderingMode(.alwaysOriginal), for: .normal)
        logoButton.addTarget(self, action: #selector(presentLogoWebsiteViewController), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoButton)
    }
    
    /// Sets the navigation bar 3 right items as listed in letf-to-right order:
    /// Favorite, Filter, Favorites.
    private func setupRightNavItems() {
        let collection = [("settings_colored" , #selector(presentSettingsViewController)),
                          ("filter_colored" , #selector(presentFilterViewController)),
                          ("favorites_colored" , #selector(presentFavoritesViewController))]
        var barButtonItems = [UIBarButtonItem]()
        for (imageName, selector) in collection {
            let itemButton = UIButton(type: .system)
            itemButton.translatesAutoresizingMaskIntoConstraints = false
            itemButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            itemButton.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
            itemButton.tintColor = FawGenColors.secondary.color
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
    
    /// Presents as push transition the About view controller web view
    /// to display the content of the fawgen website.
    /// - Warning: The www.fawgen.com site is not ready
    @objc private func presentLogoWebsiteViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let aboutVC = storyBoard.instantiateViewController(withIdentifier: "AboutVC") as! AboutViewController
        aboutVC.aboutURL = URL(string: UrlFor.fawgen)
        aboutVC.navigationItem.title = "FawGen"
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
    /// Presents as push transition the FavoritesView controller
    /// - Warning: Missing implementation for FavoritesViewController
    @objc private func presentFavoritesViewController() {
        print("pushedFavoriteButton")
    }
}


// MARK: - Keyboard notifications
extension RandomizeViewController {
    /// Notifies when the keyboard is about to show in order the displace the view
    /// accordingly of the keyboard height
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        keyboardFrame = keyboardSize.cgRectValue
        view.frame.origin.y -= SimpleAssistDisplacement()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += SimpleAssistDisplacement()
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {}
    
    /// Displaces the SimpleAssistView in order to place it in respect of the
    /// newly displayed keyboard
    private func SimpleAssistDisplacement() -> CGFloat {
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

