//
//  RandomizeVC+ModelLoading.swift
//  FawGen
//
//  Created by Erick Olibo on 30/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

// MARK: - Starting Engine
extension RandomizeViewController {
    
    public func printDeviceInfo() {
        let device = UIDevice.current
        printConsole("Model Name: \(device.modelName) - Power: \(device.processingPower.rawValue)")
    }
    
    // UNIQUE Methods that returns all type of MadeUpWords for Keywords or None (Assist & Simple)
    private func getAllTypesOfRandomWords() {
        
        toolBox.requestedQuality = (nil, nil)
        let words = "defkut, water, hotel, solder, president, startup"
        let defkut = "defkut"
        let empty = String()
        guard let allWords = toolBox.generateMadeUpWords(from: empty) else { return }
        
        var collection = [MadeUpAlgo : Set<MadeUpWord>]()
        for type in MadeUpAlgo.allCases {
            let group = allWords.filter { $0.madeUpAlgo == type }
            guard group.count != 0 else { continue }
            collection[type] = group
        }
        
        for (type, list) in collection {
            print("type: \(type.rawValue) ==> ListCount: \(list.count)")
        }
        printResult(list: Array(allWords))
    }
    
    private func printResult(list: [MadeUpWord]) {
        print("PRINTSIZE OF LIST: \(list.count)")
        //let titlesList = list.map{ $0.title }.joined(separator: " - ")
        let _ = list.map{ print($0.madeUpQuality.algoName)}
    }
    
    
    
    
    
}

// MARK: - Extension for animations Setup and running
extension RandomizeViewController {
    private func enableNavigationItems() {
        navigationItem.leftBarButtonItem?.isEnabled = true
        guard let rightButtons = navigationItem.rightBarButtonItems else { return }
        let _ = rightButtons.map { $0.isEnabled = true }
    }
    
    private func disableNavigationItems() {
        navigationItem.leftBarButtonItem?.isEnabled = false
        guard let rightButtons = navigationItem.rightBarButtonItems else { return }
        let _ = rightButtons.map { $0.isEnabled = false }
    }
    
    public func loadModelToMemory() {
        start = Date()
        setupLaunchView()
        animateAppear()
        disableNavigationItems()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let _model = PersistentModel.shared.model
            _model.delegate = self
            _model.initialize()
            let _kNN = PersistentKNN.shared.kNN
            let _toolBox = ToolBox()
            DispatchQueue.main.async { [weak self] in
                self?.model = _model
                self?.kNN = _kNN
                self?.toolBox = _toolBox
                self?.toolBox.delegate = self
                printConsole("from Queue to model: \(self!.start.toNowProcessDuration)")
                self?.animateDissapear()
                self?.enableNavigationItems()
            }
        }
    }
    
    
    public func setUpBackground() {
        launchBackground = UIView(frame: self.view.bounds)
        launchBackground.backgroundColor = .white
        launchBackground.center = self.view.center
        self.view.addSubview(launchBackground)
    }
    
    private func setupLaunchView() {
        let launchFrame = CGRect(x: 0, y: 0, width: 200, height: 300)
        launchView = StartingEngine(frame: launchFrame)
        
        // Set the view offSet
        let launchViewCenterX = self.view.center.x
        printConsole("View Center = \(self.view.center) - View bound: \(self.view.bounds)")
        let launchViewCenterY = self.view.bounds.height + (launchFrame.height / 2) + 10
        let launchViewCenter = CGPoint(x: launchViewCenterX, y: launchViewCenterY)
        launchView.center = launchViewCenter
        self.view.addSubview(launchView)
    }
    
    private func animateAppear() {
        difference = self.view.center.y - launchView.center.y
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.launchView.startAnimating()
            self.launchView.transform = CGAffineTransform(translationX: 0, y: self.difference)
        }) { (_) in
            
        }
        
    }
    
    private func animateDissapear() {
        launchView.stopAnimating()
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: .curveEaseIn, animations: {
            self.launchView.transform = CGAffineTransform(translationX: 0, y: -self.difference)
            self.launchBackground.alpha = 0
        }) { (_) in
            self.launchView.stopAnimating()
            self.launchBackground.removeFromSuperview()
            self.launchView.removeFromSuperview()
        }
    }
    
    
}

extension RandomizeViewController: ModelDelegate, ToolBoxDelegate {
    
    func modelLoadingCompletion(at percent: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.launchView.progressBar.setProgressWithAnimationTo(percent)
        }
    }
    
    func toolBoxResultsReady(for task: TaskType) {
        printConsole("ToolBox Results for \(task.rawValue) are ready!")
    }
    
}
