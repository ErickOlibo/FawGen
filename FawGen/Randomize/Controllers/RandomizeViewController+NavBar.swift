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
        setupLeftNavItems()
        setupRightNavItems()
        setupRemainingNavItems()
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
        let favoriteButton = UIButton(type: .system)
        favoriteButton.setImage(UIImage(named: "favorites_filled")?.withRenderingMode(.alwaysTemplate), for: .normal)
        favoriteButton.tintColor = FawGenColors.secondary.color
        let favBtnItem = UIBarButtonItem(customView: favoriteButton)
        
        let filterButton = UIButton(type: .system)
        filterButton.setImage(UIImage(named: "filter")?.withRenderingMode(.alwaysTemplate), for: .normal)
        filterButton.tintColor = FawGenColors.secondary.color
        let filterBtnItem = UIBarButtonItem(customView: filterButton)
        
        let settingButton = UIButton(type: .system)
        settingButton.setImage(UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate), for: .normal)
        settingButton.tintColor = FawGenColors.secondary.color
        let settingBtnItem = UIBarButtonItem(customView: settingButton)
        
        favoriteButton.addTarget(self, action: #selector(pushedFavoriteButton), for: .touchUpInside)
        filterButton.addTarget(self, action: #selector(pushedFilterButton), for: .touchUpInside)
        settingButton.addTarget(self, action: #selector(pushedSettingButton), for: .touchUpInside)
    
        navigationItem.rightBarButtonItems = [settingBtnItem, filterBtnItem, favBtnItem]
    }
    
    private func setupRemainingNavItems() {
        // To make the navigation bar really white and not translucent
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    // MARK: - Buttons Push Actions
    
    @objc private func pushedLogoButton() {
        print("pushedLogoButton")
    }
    
    @objc private func pushedFilterButton() {
        print("pushedFilterButton")
    }
    
    @objc private func pushedFavoriteButton() {
        print("pushedFavoriteButton")
    }
    
    @objc private func pushedSettingButton() {
        print("pushedSettingButton")
    }
    
    
}
