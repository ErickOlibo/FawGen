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
        let collection = [("settings" , #selector(pushedSettingButton)),
                          ("filter" , #selector(pushedFilterButton)),
                          ("favorites_filled" , #selector(pushedFavoriteButton))]
        var barButtonItems = [UIBarButtonItem]()
        for (imageName, selector) in collection {
            let itemButton = UIButton(type: .system)
            itemButton.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
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
        print("pushedLogoButton")
        pushLogoWebsiteViewController()
    }
    
    @objc private func pushedFilterButton() {
        print("pushedFilterButton")
        presentFilterViewController()
    }
    
    @objc private func pushedFavoriteButton() {
        print("pushedFavoriteButton")
    }
    
    @objc private func pushedSettingButton() {
        print("pushedSettingButton")
        presentSettingsViewController()
    }
    
    // MARK: - ViewController from Right NavBar Button
    
    private func presentSettingsViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let settingsVC = storyBoard.instantiateViewController(withIdentifier: "SettingsVC")
        self.navigationController?.pushViewController(settingsVC, animated: true)
        
//        let transitionDelegate = SPStorkTransitioningDelegate()
//        previousVC.transitioningDelegate = transitionDelegate
//        previousVC.modalPresentationStyle = .custom
//        self.present(previousVC, animated: true, completion: nil)
    }
    
    private func presentFilterViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let previousVC = storyBoard.instantiateViewController(withIdentifier: "PreviousVC")
        previousVC.view.backgroundColor = .gray
        let ratio = 3.0 / CGFloat(4)
        let vcHeight = view.bounds.height * ratio // 2/3 of the phone heigth
        print("Screen: \(view.bounds.height) --> Lark: \(vcHeight)")
        self.presentAsLark(previousVC, height: vcHeight, complection: nil)
    }
    
    private func pushLogoWebsiteViewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let previousVC = storyBoard.instantiateViewController(withIdentifier: "PreviousVC")
        let backItem = UIBarButtonItem()
        backItem.title = "Test"
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(previousVC, animated: true)
    }
    
}
