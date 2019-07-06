//
//  KeywordsHistoryViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 20/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class KeywordsHistoryViewController: UITableViewController {
    
    // MARK: - Properties
    let dataBaseManager = DefaultDB()
    var historyList: [HistoryEntry] {
        return dataBaseManager.getHistory().sorted { $0.value > $1.value }
    }

    
    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.separatorStyle = .none
    }

}


extension KeywordsHistoryViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return historyList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! KeywordsHistoryCell
        let (keywords, date) = historyList[indexPath.row]
        // Configure the cell...
        
        // Get the fontAwesome and the rest
        
        cell.keywordsLabel.text = keywords
        cell.keywordsDateLabel.text = date.timeAgoSinceNow()
        guard let iconTime = FAType.FAClockO.text else { return cell }
        let space = " "
        let attributeOne = [NSAttributedString.Key.font : UIFont(name: "FontAwesome", size: 15.0)!]
        let time = NSMutableAttributedString(string: iconTime, attributes: attributeOne)
        let restTime = space + date.timeAgoSinceNow()
        //let text = iconTime + " " + date.timeAgoSinceNow()
        let attrTime = NSAttributedString(string: restTime)
        time.append(attrTime)
        cell.keywordsDateLabel.attributedText = time
        
        return cell
    }
    
}
