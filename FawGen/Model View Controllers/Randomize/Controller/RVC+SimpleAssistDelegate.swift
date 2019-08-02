//
//  RVC+SimpleAssistDelegate.swift
//  FawGen
//
//  Created by Erick Olibo on 02/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension RandomizeViewController: SimpleAssistDelegate {
    
    func querySimpleModel() {
        currentKeywords = String()
        letsGoQuery(.simple)
    }
    
    func queryAssistedModel(by keywords: String) {
        currentKeywords = keywords
        letsGoQuery(.assist, with: keywords)
    }
    
    /// Queries the model after the user has pressed Let's Go button. Depending
    /// on the type (simple or assit) a different Model Engine will be queried
    /// - Parameters:
    ///     - type: between simple and assist or without keywords or with
    ///     - keywords: string entered by the user
    public func letsGoQuery(_ type: LetsGoType, with keywords: String = String()) {
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        
        if isRepeatSimpleSet {
            if let newSetHomeView = tableView.tableFooterView as? NewSetHomeView {
                printConsole("NEW SET HOME VIEW BOUNDS: \(newSetHomeView.bounds)")
                let spinnerX = newSetHomeView.center.x
                let spinnerY = newSetHomeView.homeButton.center.y - 10
                spinner.color = FawGenColors.primary.color
                spinner.startAnimating()
                spinner.center = CGPoint(x: spinnerX, y: spinnerY)
                printConsole("Spinner Center: \(spinner.center)")
                newSetHomeView.addSubview(spinner)
                newSetHomeView.bringSubviewToFront(spinner)
                isRepeatSimpleSet = false
            }
            
        } else {
            if let simpleAssistView = tableView.tableFooterView as? SimpleAssistView {
                let spinnerY = simpleAssistView.center.y + 45.0 // Magic Numbers
                let spinnerX = simpleAssistView.bounds.width - 57.0 // Magic number
                let spinnerCenter = CGPoint(x: spinnerX, y: spinnerY)
                spinner.startAnimating()
                spinner.center = spinnerCenter
                simpleAssistView.addSubview(spinner)
                simpleAssistView.bringSubviewToFront(spinner)
            }
        }
        
        let newType: LetsGoType = currentKeywords == String() ? .simple : .assist
        printConsole("******* TYPE: \(newType.rawValue) - KEYWORDS: \(currentKeywords)")
        var results = [FakeWord]()
        toolBox.requestedQuality = dataBaseManager.getRequestedQuality()

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            printConsole("DISPATCH GLOBAL")
            var tmpResults = [FakeWord]()
            var counter = 0
            
            while counter < 3 && tmpResults.count == 0 {
                counter += 1
                switch newType {
                case .simple:
                    if let madeUpwords = self.toolBox.generateMadeUpWords() {
                        tmpResults = madeUpwords.map{ FakeWord($0) }
                    }
                case .assist:
                    if let madeUpwords = self.toolBox.generateMadeUpWords(from: self.currentKeywords) {
                        tmpResults = madeUpwords.map{ FakeWord($0) }
                    }
                }
                
                let filteredResult = tmpResults.filter {!self.alreadyDisplayedFakeWordsTitles.contains($0.title) }
                printConsole("ROUND \(counter) - Size RESULT: \(filteredResult.count)")
                tmpResults = filteredResult
            }
            
            let toDisplayWordList = tmpResults.map { $0.title }
            self.alreadyDisplayedFakeWordsTitles.formUnion(toDisplayWordList)
            
            // ****** END the 3 iterations if zero.
            printConsole("Results from Query: \(tmpResults.count) FakeWords")
            tmpResults = self.dataSource.updatedFakeWordsResults(tmpResults)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                printConsole("DISPATCH MAIN")
                spinner.stopAnimating()
                guard tmpResults.count != 0  else {
                    printConsole("DISPATCH MAIN ==> EMPTY ZERO words")
                    printConsole("KEYWORDS FOR ZERO: \(keywords)")
                    self.showAlertForNoResults()
                    return
                }
                results = tmpResults
                self.tableView.tableFooterView = UIView(frame: CGRect.zero)
                self.tableView.beginUpdates()
                let rowsCount = self.tableView.numberOfRows(inSection: 0)
                let indexPaths = (0..<rowsCount).map { IndexPath(row: $0, section: 0)}
                
                self.tableView.deleteRows(at: indexPaths, with: .automatic)
                self.dataSource.items = results
                self.currentRoundItems = results
                self.dataSource.indexPaths = Set<IndexPath>()
                var indexPathsNew = [IndexPath]()
                for idx in 0..<self.dataSource.items.count {
                    let path = IndexPath(row: idx, section: 0)
                    indexPathsNew.append(path)
                }
                self.tableView.insertRows(at: indexPathsNew, with: .automatic)
                self.tableView.endUpdates()
                
                if let firstIndex = indexPathsNew.first {
                    self.tableView.scrollToRow(at: firstIndex, at: .top, animated: true)
                }
                self.simpleAssistOrNewSetHomeUI()
            }
        }
    }
    
    /// Makes sure the words were not used before
    private func getNewRandomItems(count: Int) -> [FakeWord] {
        return dataSource.getFontsToFakeword()
    }
    
}
