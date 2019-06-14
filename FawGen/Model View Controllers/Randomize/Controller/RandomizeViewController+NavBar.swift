//
//  RandomizeViewController+NavBar.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

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
        let backItem = UIBarButtonItem()
        backItem.title = "Randomize"
        navigationItem.backBarButtonItem = backItem
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
