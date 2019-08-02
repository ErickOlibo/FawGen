//
//  RVC+NotificationHandler.swift
//  FawGen
//
//  Created by Erick Olibo on 02/08/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension RandomizeViewController {
    
    /// Place to get notification for UIApplication Active state
    public func applicationNotificationHandler(_ state: ObserverState) {
        switch state {
        case .add:
            NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        case .remove:
            NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
    
    /// Place to remove or add keyboard notification handler
    public func keyboardNotificationHandler(_ state: ObserverState) {
        switch state {
        case .add:
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        case .remove:
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        }
    }
    
    @objc func applicationWillResignActive(_ notification : NSNotification) {
        if let simpleAssistView = tableView.tableFooterView as? SimpleAssistView {
            simpleAssistView.keywordsGrowningTextView.resignFirstResponder()
        }
        keyboardNotificationHandler(.remove)
    }
    
    @objc func applicationDidBecomeActive(_ notification : NSNotification) {
        keyboardNotificationHandler(.add)
    }
    
    
    /// Selects the right TableFooterView to present. Depending on the
    /// size of the DataSource Items count. If 0 then AssistHome, else
    /// NewSetHome
    public func simpleAssistOrNewSetHomeUI() {
        if dataSource.items.count > 0 {
            tableView.isScrollEnabled = true
            let viewBounds = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60)
            let newSetHomeView = NewSetHomeView(frame: viewBounds)
            newSetHomeView.newSetHomeDelegate = self
            tableView.tableFooterView = newSetHomeView
            
        } else {
            let simpleAssistView = SimpleAssistView(frame: tableView.bounds)
            simpleAssistView.simpleAssistDelegate = self
            //letsGoBtn = simpleAssistView.letsGoButton
            tableView.tableFooterView = simpleAssistView
            tableView.isScrollEnabled = false
            //printConsole("[FooterView Bounds] - \(tableView.tableFooterView!.bounds)")
        }
    }
    
}


// MARK: - Keyboard notifications
extension RandomizeViewController {
    /// Notifies when the keyboard is about to show in order the displace the view
    /// accordingly of the keyboard height
    @objc func keyboardWillShow(notification: NSNotification) {
        if let simpleAssistView = tableView.tableFooterView as? SimpleAssistView,
            simpleAssistView.keywordsGrowningTextView.isFirstResponder {
            //printConsole("In KEYBOARD WILL SHOW, Growing is First Responder")
            guard let userInfo = notification.userInfo else { return }
            guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            keyboardFrame = keyboardSize.cgRectValue
            printConsole("[keyboardWillShow] - About to Displace UP")
            if !isDisplacedUp {
                view.frame.origin.y -= SimpleAssistDisplacement()
                isDisplacedUp = true
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let simpleAssistView = tableView.tableFooterView as? SimpleAssistView,
            simpleAssistView.keywordsGrowningTextView.isFirstResponder {
            //printConsole("In KEYBOARD WILL HIDE, Growing is First Responder")
            printConsole("[keyboardWillHide] - About to Displace DOWN")
            if isDisplacedUp {
                view.frame.origin.y += SimpleAssistDisplacement()
                isDisplacedUp = false
            }
        }
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        //printConsole("[keyboardDidHide] JUST HIDE!")
    }
    
    /// Displaces the SimpleAssistView in order to place it in respect of the
    /// newly displayed keyboard
    private func SimpleAssistDisplacement() -> CGFloat {
        //printConsole("FooterView in SimpleAssistDisplacement")
        let displacement = 0.0 + (UIDevice().safeAreaBottomHeight() / 2)
        let keyboardHeight = keyboardFrame.height
        guard let footer = tableView.tableFooterView?.bounds else { return displacement }
        
        let heightBelow = (footer.height / 2) - halfHeightSimpleAssistView - 10.0
        switch  keyboardHeight {
        case let height where height == heightBelow:
            return displacement
        case let height where height < heightBelow:
            return heightBelow - height + displacement
        case let height where height > heightBelow:
            return height - heightBelow + displacement
        default:
            break
        }
        return displacement
    }
    
}
