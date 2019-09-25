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
    private let pathFawGen = "https://itunes.apple.com/app/id1475236378"
    
    private struct AppIndexPath {
        static let algoExplanation = IndexPath(row: 1, section: 0)
        static let faq = IndexPath(row: 0, section: 1)
        static let feedback = IndexPath(row: 1, section: 1)
//        static let story = IndexPath(row: 0, section: 2)
        static let terms = IndexPath(row: 0, section: 2)
        static let policy = IndexPath(row: 1, section: 2)
        static let openSource = IndexPath(row: 2, section: 2)
//        static let disclamer = IndexPath(row: 4, section: 2)
        static let writeReview = IndexPath(row: 3, section: 2)
        static let shareApp = IndexPath(row: 4, section: 2)
    }
    
    
    let dataBaseManager = DefaultDB()
    let reachability = Reachability()
    var indexPaths = [IndexPath]()
    let titles = ["Algo Explanation", "F.A.Q.", "Feedback", "Terms of Use", "Privacy Policy", "Open-source Libraries", "Write a Review"]
    var indexPathsCollection = [IndexPath : String]()
    
    // MARK: - Outlets
    @IBOutlet weak var historyCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        updateHistoryUI()
        setIndexPaths()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHistoryUI()
    }
    
    
    private func setIndexPaths() {
        indexPaths.append(AppIndexPath.algoExplanation)
        indexPaths.append(AppIndexPath.faq)
        indexPaths.append(AppIndexPath.feedback)
//        indexPaths.append(AppIndexPath.story)
        indexPaths.append(AppIndexPath.terms)
        indexPaths.append(AppIndexPath.policy)
        indexPaths.append(AppIndexPath.openSource)
//        indexPaths.append(AppIndexPath.disclamer)
        indexPaths.append(AppIndexPath.writeReview)
        for (idx, indexPath) in indexPaths.enumerated() {
            indexPathsCollection[indexPath] = titles[idx]
        }
    }
    
    // Update the UI specially for the History list count
    /// Updates the number of keywords hitory query performed
    /// during the lifespan of the app
    /// - Note: There is a need to implement a reset button
    /// for the history list
    private func updateHistoryUI() {
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
        
        if (segue.identifier == "Algo Explanation") {
            guard let destination = segue.destination as? AboutViewController else { return }
            destination.aboutURL = URL(string: UrlFor.algoExplanation)
            destination.navigationItem.title = "Algo Explanation"
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
        
//        if (segue.identifier == "FawGen Story") {
//            guard let destination = segue.destination as? AboutViewController else { return }
//            destination.aboutURL = URL(string: UrlFor.fawgenStory)
//            destination.navigationItem.title = "FawGen Story"
//        }
        
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
        
//        if (segue.identifier == "Disclaimer") {
//            guard let destination = segue.destination as? AboutViewController else { return }
//            destination.aboutURL = URL(string: UrlFor.disclaimer)
//            destination.navigationItem.title = "Disclaimer"
//        }
        
    }
    
    // TableView delegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if reachability.networkStatus() == .unavailable {
            var title = "this"
            if let tmpTitle = indexPathsCollection[indexPath] {
                title = "the \(tmpTitle)"
            }
            if let controller = reachability.internetConnectionAlertController(for: title) {
                present(controller, animated: true, completion: nil)
            }
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == AppIndexPath.writeReview {
            writeReview()
        }
        
        if indexPath == AppIndexPath.shareApp {
            shareApp()
        }
        
    }
    
    
}

extension SettingsViewController {

    
    /// Sends the user to the App Store to wwrite a review about the app
    private func writeReview() {
        guard let productURL = URL(string: pathFawGen) else { return }
        var compenents = URLComponents(url: productURL, resolvingAgainstBaseURL: false)
        compenents?.queryItems = [ URLQueryItem(name: "action", value: "write-review") ]
        
        guard let writeReviewURL = compenents?.url else { return }
        UIApplication.shared.open(writeReviewURL)
    }
    
    
    /// Opens the pop menu to give options on sharing the app with friends
    private func shareApp() {
        guard let productURL = URL(string: pathFawGen) else { return }
        let activityViewController = UIActivityViewController(activityItems: [productURL], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
}
