//
//  SimpleAssistView+Extensions.swift
//  FawGen
//
//  Created by Erick Olibo on 24/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension SimpleAssistView {
    
    // MARK: - Methods
    public func commonInitialization() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(view)
        state = .close
    }
    
    private func updateCornerLetsGoButton() {
        switch state {
        case .close:
            letsGoButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case .open:
            letsGoButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }
    
    public func keywordsFrameSetup() {
        keywordsFrameView.clipsToBounds = true
        keywordsFrameView.layer.cornerRadius = 10
        keywordsFrameView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        keywordsFrameView.backgroundColor = FawGenColors.secondary.color
        
    }
    
    public func keywordsGrowningTextSetup() {
        keywordsGrowningTextView.delegate = self
        keywordsGrowningTextView.smartInsertDeleteType = .no
        textMaxLength = keywordsGrowningTextView.maxLength
    }
    
    public func letsGoButtonSetup() {
        letsGoButton.clipsToBounds = true
        letsGoButton.layer.cornerRadius = 10
    }
    
    public func textLengthLabelSetup() {
        textLengthLabel.text = ""
    }
    
    public func closeStack() {
        topView.alpha = 1
        UIView.animate(withDuration: 0.5) {
            self.topView.alpha = 0
        }
        state = .close
    }
    
    public func openStack() {
        topView.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.topView.alpha = 1
        }
        state = .open
    }
    
    private func updateSimpleAssist() {
        switch state {
        case . close:
            simpleButton.backgroundColor = FawGenColors.secondary.color
            assistButton.backgroundColor = .darkGray
        case .open:
            simpleButton.backgroundColor = .darkGray
            assistButton.backgroundColor = FawGenColors.secondary.color
        }
    }
    
    public func toggle() {
        print("Toggled() --> State is: \(state.rawValue)")
        updateCornerLetsGoButton()
        updateSimpleAssist()
        stackView.arrangedSubviews[openViewIndex].isHidden = isStateClosed()
        
    }
    
    private func isStateClosed() -> Bool {
        return state == .close
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        keywordsGrowningTextView.resignFirstResponder()
    }
    
    
}

// MARK: - Text View Delegate
extension SimpleAssistView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let text = keywordsGrowningTextView.text {
            textLimitUI(for: text.count)
        }
    }
    
    private func textLimitUI(for length: Int ) {
        let remain = textMaxLength - length
        
        switch length {
        case let len where len <= 0:
            textLengthLabel.text = ""
        case let len where len > 0 && len <= (textMaxLength - 11):
            textLengthLabel.text = String(remain)
            textLengthLabel.textColor = .white
        case let len where len > (textMaxLength - 11) && len <= textMaxLength:
            textLengthLabel.text = String(remain)
            textLengthLabel.textColor = FawGenColors.tertiary.color
        default:
            textLengthLabel.text = "Too long!"
            textLengthLabel.textColor = FawGenColors.primary.color
            fireHapticFeedback()
            textLengthLabel.shake(transform: CGAffineTransform(translationX: 5, y: 0), duration: 0.3)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
    }
    
}


// MARK: - Let's Go Button
extension SimpleAssistView {
    
    public func letsGoSimple() {
        print("Let's Go SIMPLE")
        
        // Send to model
    }
    
    public func letsGoAssist() {
        print("Let's Go ASSIST")
        
        // Save to history
        if let text = keywordsGrowningTextView.text {
            if text.count == 0 {
                letsGoSimple()
            } else {
                saveToHistory(text)
                keywordsGrowningTextView.text = String()
                textLengthLabel.text = String()
            }
            
        }
        // Send to model
        
    }
    
    
}


// MARK: - Keywords and Description History
extension SimpleAssistView {
    /// records the keywords query to the UserDefault Database. The keywords
    /// and the date when it was queried is saved
    /// - Parameter keywords: the string text to query against
    public func saveToHistory(_ keywords: String) {
        let now = Date()
        if DefaultDB.getValue(for: .history)! as KeywordsHistory? == nil {
            DefaultDB.save([keywords : now], for: .history)
        } else {
            var savedHistory = DefaultDB.getValue(for: .history)! as KeywordsHistory
            savedHistory[keywords] = now
            let sanitizedHistory = DefaultDB.sanitize(savedHistory)
            DefaultDB.save(sanitizedHistory, for: .history)
        }
    }
    
    
    
}



// MARK: - animation
extension SimpleAssistView {
    // MARK: - Haptic Feedback
    public func fireHapticFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
    }
}


extension UIView {
    public func shake(transform: CGAffineTransform, duration: TimeInterval) {
        
        self.transform = transform
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}
