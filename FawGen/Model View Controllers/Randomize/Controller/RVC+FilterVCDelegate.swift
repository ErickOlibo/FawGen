//
//  RVC+FilterVCDelegate.swift
//  FawGen
//
//  Created by Erick Olibo on 02/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension RandomizeViewController: FilterViewControllerDelegate {
    func filterViewControllerDidDisappear() {
        filterCurrentRound()
        printConsole("FilterVC Will Disappear Delegate and DataSource count: \(dataSource.items.count) - CurrentRoundItems: \(currentRoundItems.count)")
    }
    
    
    
    // filterData with respect to new change
    private func filterCurrentRound() {
        let items = currentRoundItems.filter { $0.isOfCurrentFiltersQuality() }
        reloadAllDataIfNecessary(with: items)
        
    }
    
    
    private func reloadAllDataIfNecessary(with items: [FakeWord]) {
        
        if items == dataSource.items { return }
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.beginUpdates()
        let rowsCount = self.tableView.numberOfRows(inSection: 0)
        let indexPaths = (0..<rowsCount).map { IndexPath(row: $0, section: 0)}
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        dataSource.items = items
        dataSource.indexPaths = Set<IndexPath>()
        var indexPathsNew = [IndexPath]()
        for idx in 0..<self.dataSource.items.count {
            let path = IndexPath(row: idx, section: 0)
            indexPathsNew.append(path)
        }
        tableView.insertRows(at: indexPathsNew, with: .automatic)
        tableView.endUpdates()
        
        if let firstIndex = indexPathsNew.first {
            tableView.scrollToRow(at: firstIndex, at: .top, animated: true)
        }
        simpleAssistOrNewSetHomeUI()
    }
    
}
