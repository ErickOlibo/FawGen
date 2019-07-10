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
    let dataBaseManager = DefaultDB()
    let reachability = Reachability()
    var indexPaths = [IndexPath]()
    let titles = ["Fields Explanation", "F.A.Q.", "Feedback", "FawGen Story", "Terms of Use", "Privacy Policy", "Open-source Libraries", "Disclamer"]
    var indexPathsCollection = [IndexPath : String]()
    
    // MARK: - Outlets
    @IBOutlet weak var historyCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        updateUI()
        setIndexPaths()
        
        
    }
    
    
    private func setIndexPaths() {
        let explanation = IndexPath(row: 1, section: 0)
        let faq = IndexPath(row: 0, section: 1)
        let feedback = IndexPath(row: 1, section: 1)
        let story = IndexPath(row: 0, section: 2)
        let terms = IndexPath(row: 1, section: 2)
        let policy = IndexPath(row: 2, section: 2)
        let openSource = IndexPath(row: 3, section: 2)
        let disclamer = IndexPath(row: 4, section: 2)
        indexPaths.append(explanation)
        indexPaths.append(faq)
        indexPaths.append(feedback)
        indexPaths.append(story)
        indexPaths.append(terms)
        indexPaths.append(policy)
        indexPaths.append(openSource)
        indexPaths.append(disclamer)
        for (idx, indexPath) in indexPaths.enumerated() {
            indexPathsCollection[indexPath] = titles[idx]
        }
    }
    
    // Update the UI specially for the History list count
    /// Updates the number of keywords hitory query performed
    /// during the lifespan of the app
    /// - Note: There is a need to implement a reset button
    /// for the history list
    private func updateUI() {
        let historySize = dataBaseManager.getHistory().count
        historyCount.text = String(historySize)
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
        }
        
        if (segue.identifier == "FAQ") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.faq)
            destination.navigationItem.title = "F.A.Q."
        }
        
        if (segue.identifier == "Feedback") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.feedback)
            destination.navigationItem.title = "Feedback"
        }
        
        if (segue.identifier == "FawGen Story") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.fawgenStory)
            destination.navigationItem.title = "FawGen Story"
        }
        
        if (segue.identifier == "Terms of Use") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.termOfUse)
            destination.navigationItem.title = "Terms of Use"
        }
        
        if (segue.identifier == "Privacy Policy") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.privacy)
            destination.navigationItem.title = "Privacy Policy"
        }
        
        if (segue.identifier == "Open-source Libraries") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.openSource)
            destination.navigationItem.title = "Licenses"
        }
        
        if (segue.identifier == "Disclaimer") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.disclaimer)
            destination.navigationItem.title = "Disclaimer"
        }
        
    }
    
    // TableView delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if reachability.networkStatus() == .unavailable {
            var title = String()
            if let tmpTitle = indexPathsCollection[indexPath] {
                title = "the \(tmpTitle)"
            } else {
                title = "this"
            }
            if let controller = reachability.internetConnectionAlertController(for: title) {
                present(controller, animated: true, completion: nil)
            }
            return nil
        }
        return indexPath
    }
}
