//
//  SettingsViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 07/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Outlets
    @IBOutlet weak var historyCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        updateUI()
        
    }
    
    
    // Update the UI specially for the History list count
    /// Updates the number of keywords hitory query performed
    /// during the lifespan of the app
    /// - Note: There is a need to implement a reset button
    /// for the history list
    private func updateUI() {
        print("UpdateUI")
        var historyStoredCount = 0
        if let history = DefaultDB.getValue(for: .history)! as KeywordsHistory? {
            historyStoredCount = history.count
        }

        historyCount.text = String(historyStoredCount)
        historyCount.textColor = FawGenColors.primary.color
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "Keywords History") {
            guard let destination = segue.destination as? KeywordsHistoryViewController else { return }
            destination.navigationItem.title = "History"
        }
        
        if (segue.identifier == "Fields Explanation") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.explanation)
            destination.navigationItem.title = "Explanation"
            print(UrlFor.explanation)
        }
        
//        if (segue.identifier == "Checker") {
//            guard let destination = segue.destination as? CheckerViewController else { return }
//            destination.navigationItem.title = "Checker"
//        }
        
        if (segue.identifier == "FAQ") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.faq)
            destination.navigationItem.title = "F.A.Q."
            print(UrlFor.faq)
        }
        
        if (segue.identifier == "Feedback") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.feedback)
            destination.navigationItem.title = "Feedback"
            print(UrlFor.feedback)
        }
        
        if (segue.identifier == "Terms of Use") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.termOfUse)
            destination.navigationItem.title = "Terms of Use"
            print(UrlFor.termOfUse)
        }
        
        if (segue.identifier == "Privacy Policy") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.privacy)
            destination.navigationItem.title = "Privacy Policy"
            print(UrlFor.privacy)
        }
        
        if (segue.identifier == "Open-source Libraries") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.openSource)
            destination.navigationItem.title = "Licenses"
            print(UrlFor.openSource)
        }
        
        if (segue.identifier == "Disclaimer") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.disclaimer)
            destination.navigationItem.title = "Disclaimer"
            print(UrlFor.disclaimer)
        }
        
    }
    
    
}
