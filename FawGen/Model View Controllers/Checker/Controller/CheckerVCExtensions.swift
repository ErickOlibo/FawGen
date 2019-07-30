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
    
    /// Toggles between Save and Remove to/from UserDataBase
    public func toggleSaveRemove() {
        // will need to implement the save and remove from DefaultDatabase
        
        toggleSave()
        
    }
    
    /// Toggles the UI/UX layout for the save button
    private func toggleSave() {
        if tmpFakeWord.isSaved() {
            dataBaseManager.removeFromList(tmpFakeWord)
        } else {
            dataBaseManager.addToList(tmpFakeWord)
        }
        updateSave()
    }
    
    private func updateSave() {
        if tmpFakeWord.isSaved() {
            saveButton.backgroundColor = FawGenColors.primary.color
            saveButton.setTitle("saved")
            isSaved = true
        } else {
            saveButton.backgroundColor = .lightGray
            saveButton.setTitle("save")
            isSaved = false
        }
    }
    
    
    
    public func touchedSendButton() {
        whichInternetConnection()
        guard reachability.networkStatus() != .unavailable else {
            setUserNotificationForNoInternet()
            return
        }
        if textField.isFirstResponder { textField.resignFirstResponder() }
        textField.isHidden = true
        textField.text = String()
        textField.counterLabel.text = String()
        setupSendButton()
        wasQueried = true
        updateEnabledTextToSpeechSaveForSendQuery()
        if let userText = typedWord.text, userText.count > 5 { userEnteredWord = userText
            tmpFakeWord = FakeWord(userText)
            updateSave()
        }
        getDomainExtensionsAvailability()
        getSocialNetworksAvailability()
        resetCount = 0
        
    }
    
    private func setUserNotificationForNoInternet() {
        printConsole("setUserNotificationForNoInternet")
    }
    
    public func whichInternetConnection() {
        let status = reachability.networkStatus()
        printConsole("REACHABILITY: \(status.rawValue)")
        
    }
    
    public func touchedTextToSpeech() {
        guard let text = typedWord.text else { return }
        let tts = TextToSpeech()
        let toSpeak = text.lowercased().capitalized
        tts.speakFakeWord(toSpeak, accent: .american)
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
        printConsole("didReachMaxLength")
    }
}



extension CheckerViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        
    }
    
    @objc public func editingChanged() {
        domainGroupIsDone = false
        socialGroupIsDone = false
        wasQueried = false
        isSaved = false
        resetCount += 1
        updateDomainSocialStatus()
        updateEnabledTextToSpeechSaveForSendQuery()
        guard let currentText = textField.text else { return }
        let safeText = trimmedFromNoneAlphabetic(currentText)
        textField.text = safeText
        typedWord.text = safeText.uppercased()
        textField.counterLabel.text = String(safeText.count)
        setupSendButton()
    }

    
    /// Sets the color of the character counter with the proper
    /// limits
    /// - Parameter size: The number of characters in the string to
    /// define the proper counter Text color
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

    /// Trims the none Alphabetic characters from the text being typed
    /// in the TextField area.
    /// - Parameter text: The text being currently entered in the text
    /// field.
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
        
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if sendButton.isEnabled { touchedSendButton() }
        textField.resignFirstResponder()
        return true
    }

    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
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
