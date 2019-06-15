//
//  DataSource.swift
//  FawGen
//
//  Created by Erick Olibo on 15/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit
final class DataSource: NSObject, UITableViewDataSource {
    private let cellIdentifier = "RandomizeCell"
    
    private var items: [String] = ["ability", "about", "above", "accept", "according", "account", "across", "action", "activity", "actually", "address", "administration", "admit", "adult", "affect", "after", "again", "against", "agency", "agent", "agree", "agreement", "ahead", "allow", "almost", "alone", "along", "already", "although", "always", "American", "among", "amount", "analysis", "animal", "another", "answer", "anyone", "anything"]
    
    
    private var indexPaths: Set<IndexPath> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! RandomizeCell
        let title = items[indexPath.row]
        
        cell.update(title: title)
        
        cell.state = cellIsExpanded(at: indexPath) ? .expanded : .collapsed
        
        return cell
    }
    
    
    
    
}

extension DataSource {
    func cellIsExpanded(at indexPath: IndexPath) -> Bool {
        return indexPaths.contains(indexPath)
    }
    
    func addExpandedIndexPath(_ indexPath: IndexPath) {
        indexPaths.insert(indexPath)
    }
    
    func removeExpandedIndexPath(_ indexPath: IndexPath) {
        indexPaths.remove(indexPath)
    }
}

extension DataSource {
    subscript(indexPath: IndexPath) -> String {
        return items[indexPath.row]
    }
}
