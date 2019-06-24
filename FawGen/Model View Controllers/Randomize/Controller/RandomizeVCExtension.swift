//
//  RandomizeVCExtension.swift
//  FawGen
//
//  Created by Erick Olibo on 14/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

// MARK: - Keyboard notifications
extension RandomizeViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        keyboardFrame = keyboardSize.cgRectValue
        view.frame.origin.y -= SimpleAssistDisplacement()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += SimpleAssistDisplacement()
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {

    }
    
    
    private func SimpleAssistDisplacement() -> CGFloat {
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
