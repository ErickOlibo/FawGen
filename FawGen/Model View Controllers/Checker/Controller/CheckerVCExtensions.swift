//
//  CheckerVCExtensions.swift
//  FawGen
//
//  Created by Erick Olibo on 28/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

// MARK: - Action buttons
extension CheckerViewController {
    
    public func toggleSaveRemove() {
        // will need to implement the save and remove from DefaultDatabase
        
        toggleSave()
        
    }
    
    private func toggleSave() {
        if isSaved {
            // It was saved, need to remove
            saveButton.backgroundColor = .lightGray
            saveButton.setTitle("save")
            isSaved = false
        } else {
            // Was not in list need to be saved
            saveButton.backgroundColor = FawGenColors.primary.color
            saveButton.setTitle("saved")
            isSaved = true
        }
    }
    
    
    public func touchedSendButton() {
        if textField.isFirstResponder { textField.resignFirstResponder() }
        textField.text = String()
        textField.counterLabel.text = String()
        setupSendButton()
        wasQueried = true
        updateEnabledTextToSpeechSaveForSendQuery()
        if let userText = typedWord.text, userText.count > 5 { userEnteredWord = userText }
        getDomainExtensionsAvailability()
        getSocialNetworksAvailability()
        resetCount = 0
        
    }
    
    public func touchedTextToSpeech() {
        guard let text = typedWord.text else { return }
        let tts = TextToSpeech()
        tts.speakFakeWord(text, accent: .american)
    }
    
    
    public func updateEnabledTextToSpeechSaveForSendQuery() {
        if wasQueried {
            textToSpeech.isHidden = false
            saveButton.isHidden = false
        } else {
            textToSpeech.isHidden = true
            saveButton.isHidden = true
        }
        
    }
    
    
    public func updateDomainSocialStatus() {
        // wasReset is the bool
        if resetCount == 1 {
            print("updateDomainSocialStatus - Was Reset")
            for domainView in domainViews {
                domainView.status = .normal
            }
            for socialView in socialViews {
                socialView.status = .normal
            }
        }
    }
}


extension CheckerViewController: TextFieldCounterDelegate {
    func didReachMaxLength(textField: TextFieldCounter) {
        print("didReachMaxLength")
    }
}



extension CheckerViewController: UITextFieldDelegate {
    
    // Dismiss keyboard at touch outside the textField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        
    }
    
    @objc public func editingChanged() {
        print("editingChanged")
        wasQueried = false
        isSaved = false
        //wasReset = true
        resetCount += 1
        print("Reset Count: \(resetCount)")
        updateDomainSocialStatus()
        updateEnabledTextToSpeechSaveForSendQuery()
        guard let currentText = textField.text else { return }
        print(currentText)
        let safeText = trimmedFromNoneAlphabetic(currentText)
        textField.text = safeText
        typedWord.text = safeText.uppercased()
        textField.counterLabel.text = String(safeText.count)
        setupSendButton()
    }
    
    private func updateSendButton() {
        
    }
    
    
    
    private func charactersCountColor(_ size: Int) {
        switch size {
        case let size where size < 6:
            textField.counterColor = .clear
        case let size where size >= 6 && size < textField.maxLength:
            textField.counterColor = FawGenColors.secondary.color
        case let size where size >= textField.maxLength:
            textField.counterColor = FawGenColors.primary.color
        default:
            break
        }
    }

    private func trimmedFromNoneAlphabetic(_ text: String) -> String {
        var safeString = String()
        for char in text {
            if safeCharacters.contains(char) {
                safeString.append(char)
            } else {
                fireHapticFeedback()
                
            }
        }
        
        return safeString
    }
    
    @objc public func touchedScrollView() {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        if sendButton.isEnabled { touchedSendButton() }
        textField.resignFirstResponder()
        return true
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("textFieldShouldClear")
        
        return true
    }
    
}

extension CheckerViewController {
    // MARK: - Haptic Feedback
    /// Vibrates the device to indicate a warning
    public func fireHapticFeedback() {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        }
    }
}
