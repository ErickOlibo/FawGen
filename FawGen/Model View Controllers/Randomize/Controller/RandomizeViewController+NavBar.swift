//
//  RandomizeViewController+NavBar.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension RandomizeViewController {
    
    func setupNavigationBarItems() {
        setupRemainingNavItems()
        setupLeftNavItems()
        setupRightNavItems()
        
    }
    
    private func setupLeftNavItems() {
        // Left NavBar Item (logo button to be connected to a ViewController to display the fawgen website in a webView
        // remember how it was done in inroze
        let logoButton = UIButton(type: .system)
        logoButton.setImage(UIImage(named: "logoNavBar")?.withRenderingMode(.alwaysOriginal), for: .normal)
        logoButton.addTarget(self, action: #selector(pushedLogoButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoButton)
        
    }
    
    private func setupRightNavItems() {
        let collection = [("settings_colored" , #selector(pushedSettingButton)),
                          ("filter_colored" , #selector(pushedFilterButton)),
                          ("favorites_colored" , #selector(pushedFavoriteButton))]
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
    
    
    private func setupRemainingNavItems() {
        // To make the navigation bar really white and not translucent
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        //navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    // MARK: - Buttons Push Actions
    
    @objc private func pushedLogoButton() {
        pushLogoWebsiteViewController()
    }
    
    @objc private func pushedFilterButton() {
        presentFilterViewController()
    }
    
    @objc private func pushedFavoriteButton() {
        print("pushedFavoriteButton")
    }
    
    @objc private func pushedSettingButton() {
        presentSettingsViewController()
    }
    
    // MARK: - ViewController from Right NavBar Button
    
    /// Presents as push transition the settings view controller
    /// - Note: The SettingsViewController is access via its StoryBoard ID (identifier)
    private func presentSettingsViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = storyBoard.instantiateViewController(withIdentifier: "SettingsVC")
        self.navigationController?.pushViewController(settingsVC, animated: true)
        
    }
    
    /// Presents as Lark  transition (slides up to reveal behind)
    /// the filter view controller.
    /// - Warning: The height of display must be define in respect
    /// of the screen size (depending on the type of iPhone)
    private func presentFilterViewController() {
        // FilterViewController as child of this
        let filterVC: FilterViewController = {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            return storyBoard.instantiateViewController(withIdentifier: "FilterVC") as! FilterViewController
        }()
        
        let transitionDelegate = SPLarkTransitioningDelegate()
        filterVC.transitioningDelegate = transitionDelegate
        filterVC.modalPresentationStyle = .custom
        filterVC.modalPresentationCapturesStatusBarAppearance = true
        
        let phoneHeight = UIScreen.main.nativeBounds.height
        let (h, m) = UIDevice().currentPhoneHeightName()
        print("Phone Height: \(phoneHeight) - Device: [\(h), \(m)]")

        self.presentAsLark(filterVC, height: larkPresentHeight, complection: nil)
        
    }
    
    /// Presents as push transition the About view controller web view
    /// to display the content of the fawgen website.
    /// - Warning: The www.fawgen.com site is not ready
    private func pushLogoWebsiteViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let aboutVC = storyBoard.instantiateViewController(withIdentifier: "AboutVC") as! AboutViewController
        let backItem = UIBarButtonItem()
        backItem.title = "Randomize"
        navigationItem.backBarButtonItem = backItem
        aboutVC.aboutURL = URL(string: UrlFor.fawgen)
        aboutVC.navigationItem.title = "FawGen"
        self.navigationController?.pushViewController(aboutVC, animated: true)
    }
    
}
