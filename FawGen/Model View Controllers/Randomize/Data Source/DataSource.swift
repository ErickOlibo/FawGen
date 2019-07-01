//
//  DataSource.swift
//  FawGen
//
//  Created by Erick Olibo on 15/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

protocol DataSourceDelegate {
    func didTapShowDetailsReport(fakeWord: FakeWord)
}
final class DataSource: NSObject, UITableViewDataSource {
    private let cellIdentifier = "FakeWordCell"
    public var dataSize: Int = 0
    
    public enum QueryType {
        case simple
        case assist
    }
    
    
    public var items: [FakeWord] = {
        let dataSize = 0
        var collection = [FakeWord]()
        for _ in 0..<dataSize {
            collection.append(FakeWord())
        }
        return collection
    }()
    
    
    var delegate: DataSourceDelegate?
    private var indexPaths: Set<IndexPath> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView - numberOfRowsInSection: \(items.count)")
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! FakeWordCell
        let data = self[indexPath]
        cell.update(data: data)
        cell.delegate = self
        cell.state = cellIsOpened(at: indexPath) ? .opened : .closed
        cell.bottomView.alpha = cell.state == .opened ? 1 : 0
        return cell
    }
    
  
}

extension DataSource {
    func cellIsOpened(at indexPath: IndexPath) -> Bool {
        return indexPaths.contains(indexPath)
    }
    
    func addOpenedIndexPath(_ indexPath: IndexPath) {
        indexPaths.insert(indexPath)
    }
    
    func removeOpenedIndexPath(_ indexPath: IndexPath) {
        indexPaths.remove(indexPath)
    }
}

extension DataSource {
    subscript(indexPath: IndexPath) -> FakeWord {
        return items[indexPath.row]
    }
}


extension DataSource {
    public func getRandomItems(count: Int) -> [FakeWord] {
        var collection = [FakeWord]()
        for _ in 0..<count {
            collection.append(FakeWord())
        }
        return collection
    }
}

extension DataSource: FakeWordCellDelegate {
    func didTapShowDetails(fakeWord: FakeWord) {
        delegate?.didTapShowDetailsReport(fakeWord: fakeWord)
    }
    
    
}
