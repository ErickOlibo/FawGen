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
    public var indexPaths: Set<IndexPath> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! FakeWordCell
        let data = self[indexPath]
        cell.fakeword = data
        cell.tag = indexPath.row
        //cell.update(data: data)
        cell.delegate = self
        cell.state = cellIsOpened(at: indexPath) ? .opened : .closed
        cell.bottomView.alpha = cell.state == .opened ? 1 : 0
        return cell
    }
    
  
}

/// Add if the fakeword is the one having the open case
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
    public func getEmptyItems() -> [FakeWord] {
        return [FakeWord]()
    }

    public func getFontsToFakeword() -> [FakeWord] {
        let fontNames = FontsLister().getAllFontNames()
        var collection = [FakeWord]()
        for _ in 0..<fontNames.count {
            collection.append(FakeWord())
        }
        var fakeWordCollection = updateWithLogoNames(collection)
        for (idx, _) in fakeWordCollection.enumerated() {
            fakeWordCollection[idx].font =  fontNames[idx]
        }
        return fakeWordCollection
    }
}


extension DataSource: FakeWordCellDelegate {
    func didTapShowDetails(fakeWord: FakeWord) {
        delegate?.didTapShowDetailsReport(fakeWord: fakeWord)
    }
    
    
}
