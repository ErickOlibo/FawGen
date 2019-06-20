//
//  DataSource.swift
//  FawGen
//
//  Created by Erick Olibo on 15/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit
final class DataSource: NSObject, UITableViewDataSource {
    private let cellIdentifier = "FakeWordCell"
    
    private var items: [FakeWord] = {
        let dataSize = 30
        var collection = [FakeWord]()
        for _ in 0..<dataSize {
            collection.append(FakeWord())
        }
        return collection
    }()
    
    
    private var indexPaths: Set<IndexPath> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! FakeWordCell
        let data = self[indexPath]
        cell.update(data: data)
        cell.state = cellIsExpanded(at: indexPath) ? .expanded : .collapsed
        cell.bottomView.alpha = cell.state == .expanded ? 1 : 0
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
    subscript(indexPath: IndexPath) -> FakeWord {
        return items[indexPath.row]
    }
}
