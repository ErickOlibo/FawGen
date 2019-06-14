//
//  RandomizeViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 03/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class RandomizeViewController: UITableViewController {
    
    
    
    // Size of the keyword frame
    private(set) var keyboardFrame = CGRect()
    var larkPresentHeight = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Notification center
        NotificationCenter.default.addObserver(self, selector: #selector(RandomizeViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RandomizeViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        setLarkPresentHeight()
        setupNavigationBarItems()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }



}


extension RandomizeViewController {
    
    private func setLarkPresentHeight() {
        larkPresentHeight = 500 + UIDevice().safeAreaBottomHeight()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {

    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {

    }
}


