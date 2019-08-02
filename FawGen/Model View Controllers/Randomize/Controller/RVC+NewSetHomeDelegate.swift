//
//  RVC+NewSetHomeDelegate.swift
//  FawGen
//
//  Created by Erick Olibo on 02/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension RandomizeViewController: NewSetHomeDelegate {
    @objc func showSimpleAssist() {
        prepareForShowingSimpleAssist()
    }
    
    func queryNewSetFromSimpleModel() {
        printConsole("From Footer NewSetHome: Current keywords is: \(currentKeywords)")
        isRepeatSimpleSet = true
        letsGoQuery(.simple)
    }
    
    private func prepareForShowingSimpleAssist() {
        let newItems = dataSource.getEmptyItems()
        tableView.beginUpdates()
        let rowsCount = tableView.numberOfRows(inSection: 0)
        let indexPaths = (0..<rowsCount).map { IndexPath(row: $0, section: 0)}
        tableView.deleteRows(at: indexPaths, with: .automatic)
        dataSource.items = newItems
        tableView.endUpdates()
        simpleAssistOrNewSetHomeUI()
    }
    
    @objc func resetSimpleAssistAfterAlert() {
        
    }
    
}
