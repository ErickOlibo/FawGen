//
//  FilterVCExtension.swift
//  FawGen
//
//  Created by Erick Olibo on 09/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


// MARK: - Steppers

extension FilterViewController {
    
    /// Initializes the Steppers for the Length, Type and Symbol sliders
    public func setupSteppers() {
        for category in SettingCategory.allCases {
            let collection = getStepperCollection(for: category)
            let minMax = getStepperMinMaxValue(for: category)
            let stepper = getStepper(for: category)
            stepper.textCollection = collection
            stepper.minimumValue = minMax[0]
            stepper.maximumValue = minMax[1]
            switch category {
            case .length:
                stepper.value = DefaultDB.getValue(for: .length)! as Double
            case .type:
                stepper.value = DefaultDB.getValue(for: .type)! as Double
            case .symbol:
                stepper.value = DefaultDB.getValue(for: .symbol)! as Double
            }
            enabledStatus(for: stepper)
        }
    }
    
    /// Saves to local UserDefault database the current values for
    /// each stepper.
    public func saveSteppersValues() {
        for stepper in steppers {
            let currentValue = stepper.value
            switch stepper.tag {
            case 1:
                DefaultDB.save(currentValue as Double, for: .length)
            case 2:
                DefaultDB.save(currentValue as Double, for: .type)
            case 3:
                DefaultDB.save(currentValue as Double, for: .symbol)
            default:
                break
            }
        }
    }
    
    /// Gets the stepper of the right setting category from the outlet
    /// collection of steppers
    /// - Parameter category: a SettingCategory enum case
    /// - Returns: the right TEOStepper from the collection of steppers
    private func getStepper(for category: SettingCategory) -> TEOStepper {
        return steppers.filter{ $0.tag == category.rawValue }[0]
    }
    
    
    /// Gets the right collection [Double : String] in order to set the right
    /// steppers label for the legnth, type or symbol slider
    /// - Parameter category: a SettingCategory enum case
    /// - Returns: the right collection [Double : String] for Stepper setup
    private func getStepperCollection(for category: SettingCategory) -> [Double : String] {
        let lengthCollection: [Double : String] = [6 : "6 letters", 7 : "7 letters", 8 : "8 letters", 9 : "9 letters", 10 : "10 letters", 11 : "11 letters", 12 : "12 letters", 13 : "13 letters", 14 : "14 letters", 15 : "15 letters", 16 : "16 letters" ]
        let typeCollection: [Double : String] = [1 : "alpha", 2 : "beta", 3 : "gamma", 4 : "delta", 5 : "epsilon", 6 : "zeta"]
        let symbolCollection: [Double : String] = [1 : "popular", 2 : "common", 3 : "average", 4 : "uncommon", 5 : "rare"]
        switch category {
        case .length:
            return lengthCollection
        case .type:
            return typeCollection
        case .symbol:
            return symbolCollection
        }
    }
    
    /// Get the right minValue and maxValue in order to set up the right stepper
    /// boundaries values
    /// - Parameter category: a SettingCategory enum case
    /// - Returns: the min and max as array.
    private func getStepperMinMaxValue(for category: SettingCategory) -> [Double] {
        switch category {
        case .length:
            return [6, 16]
        case .type:
            return [1, 6]
        case .symbol:
            return [1, 5]
        }
    }
}


// MARK: - ON OFF Buttons

extension FilterViewController {
    
    /// Initializes the On Off buttons and their current status
    public func setupOnOffs() {
        for category in SettingCategory.allCases { setupOnOff(for: category) }
    }
    
    
    /// Initializes the OnOff buttons and prepare them to appear
    /// with the right status
    /// - Parameter category: a SettingCategory enum case
    private func setupOnOff(for category: SettingCategory) {
        var button = UIButton()
        switch category {
        case .length:
            button = getOnOffButton(for: .length)
        case .type:
            button = getOnOffButton(for: .type)
        case .symbol:
            button = getOnOffButton(for: .symbol)
        }
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        let status = currentOnOffStatus(for: button)
        updateOnOff(for: button, with: status)
    }
    
    /// Keep the OnOff Steppers indicators in sync with the UserDefault
    /// database. Enables or disables the touch actions and the visibility
    /// of the Button
    /// - Parameter stepper: a stepper from the Steppers collection
    private func enabledStatus(for stepper: TEOStepper) {
        var onOffIsEnabled = false
        switch stepper.tag {
        case 1:
            onOffIsEnabled = DefaultDB.getValue(for: .lengthOnOff)! as Bool
        case 2:
            onOffIsEnabled = DefaultDB.getValue(for: .typeOnOff)! as Bool
        case 3:
            onOffIsEnabled = DefaultDB.getValue(for: .symbolOnOff)! as Bool
        default:
            break
        }
        
        stepper.isEnabled = onOffIsEnabled
        stepper.labelBackgroundColor = onOffIsEnabled ? FawGenColors.primary.color : .darkGray
        stepper.buttonsBackgroundColor = onOffIsEnabled ? FawGenColors.primaryDark.color : .darkGray
        stepper.limitHitAnimationColor = onOffIsEnabled ? FawGenColors.primary.color : .gray
        stepper.buttonsTextColor = onOffIsEnabled ? .white : .clear
        stepper.labelTextColor = onOffIsEnabled ? .white : .clear
        
    }
    
    /// Gets the button of the right setting category from the outlet
    /// collection of onOffs (UIButton)
    /// - Parameter category: a SettingCategory enum case
    /// - Returns: the right OnOff UIButton from the collection of buttons
    private func getOnOffButton(for category: SettingCategory) -> UIButton {
        return onOffs.filter{ $0.tag == category.rawValue }[0]
    }
    
    
    /// Returns the current OnOff status, as Bool, for the button that was tapped
    /// - Parameter sender: UIButton from OnOffs button collection
    private func currentOnOffStatus(for sender: UIButton) -> Bool {
        switch sender.tag {
        case 1:
            return DefaultDB.getValue(for: .lengthOnOff)! as Bool
        case 2:
            return DefaultDB.getValue(for: .typeOnOff)! as Bool
        case 3:
            return DefaultDB.getValue(for: .symbolOnOff)! as Bool
        default:
            break
        }
        return false
    }
    
    
    /// Switches between ON and OFF for the button that was touched
    /// - Parameter sender: UIButton from OnOffs button collection
    public func switchOnOff(for sender: UIButton) {
        let status = currentOnOffStatus(for: sender)
        var stepper = TEOStepper()
        switch sender.tag {
        case 1:
            DefaultDB.save(!status, for: .lengthOnOff)
            stepper = getStepper(for: .length)
        case 2:
            DefaultDB.save(!status, for: .typeOnOff)
            stepper = getStepper(for: .type)
        case 3:
            DefaultDB.save(!status, for: .symbolOnOff)
            stepper = getStepper(for: .symbol)
        default:
            break
        }
        enabledStatus(for: stepper)
        updateOnOff(for: sender, with: !status)
        
    }
    
    
    /// Returns the text that should be displayed inside the OnOff buttons
    /// - Parameter sender: UIButton from OnOffs button collection
    private func onOfftext(for sender: UIButton) -> String {
        let onOffLabels = ["Length\n", "Type\n", "Symbol\n"]
        return onOffLabels[sender.tag - 1]
    }
    
    
    /// updates the OnOff button to a chosen status Bool
    /// - Parameters:
    ///     - sender: UIButton from OnOffs button collection
    ///     - status: update the OnOff button to rather On or Off
    private func updateOnOff(for sender: UIButton, with status: Bool) {
        let normal = onOfftext(for: sender)
        let isOn = status ? "On" : "Off"
        let attributedLength = NSMutableAttributedString(string: normal)
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        let attributedBold = NSMutableAttributedString(string: isOn, attributes: attrs)
        attributedLength.append(attributedBold)
        if status {
            sender.setAttributedTitle(attributedLength, for: .normal)
            sender.titleLabel?.textColor = .white
            sender.backgroundColor = FawGenColors.primary.color
        } else {
            sender.setAttributedTitle(attributedLength, for: .normal)
            sender.titleLabel?.textColor = .white
            sender.backgroundColor = .darkGray
        }
    }
    
    
}


// MARK: - User Database
// Extension for the UserDefaults initial state.
// Should only be initialized at the first time FilterVC
// is loaded.
extension FilterViewController {
    
    /// Sets up the initial default values (at first run) for the Length, Type
    /// and Symbol steppers and Buttons
    public func setupDataBase() {
        
        if DefaultDB.getValue(for: .length)! as Double? == nil {
            DefaultDB.save(8.0 as Double, for: .length)
        }
        
        if DefaultDB.getValue(for: .lengthOnOff)! as Bool? == nil {
            DefaultDB.save(false, for: .lengthOnOff)
        }
        
        if DefaultDB.getValue(for: .type)! as Double? == nil {
            DefaultDB.save(3.0 as Double, for: .type)
        }
        
        if DefaultDB.getValue(for: .typeOnOff)! as Bool? == nil {
            DefaultDB.save(false, for: .typeOnOff)
        }
        
        if DefaultDB.getValue(for: .symbol)! as Double? == nil {
            DefaultDB.save(3.0 as Double, for: .symbol)
        }
        
        if DefaultDB.getValue(for: .symbolOnOff)! as Bool? == nil {
            DefaultDB.save(false, for: .symbolOnOff)
        }
    }
}


// MARK: - Keywords Description

extension FilterViewController {
    
    /// Sets up the initial conditions for the Advanced (randomWords via keywords)
    public func setupKeywords() {
        keywordsTextField.placeholderColor = FawGenColors.primary.color
        keywordsTextField.smartInsertDeleteType = .no
        keywordsTextField.delegate = self
        advancedLabel.textColor = .white
        sendButton.layer.cornerRadius = sendButton.bounds.height / 2
        sendButton.setImage(UIImage(named: "sendSmall")?.withRenderingMode(.alwaysTemplate), for: .normal)
        updateSendButton(isActive: false)
        keywordsTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        setWordsLevelMeter()
    }
    
    
    /// set up the meter level in respect how many keywords are
    /// present in the overall model corpus.
    /// - Parameter count: is the number of words find in corpus
    private func setWordsLevelMeter(for count: Int = 0) {
        for levelView in wordsLevelMeter {
            levelView.backgroundColor = levelView.tag <= count ? FawGenColors.primary.color : .darkGray
        }
    }
    
    
    /// return the number of keywords that are part of the model's corpus
    /// - Parameter keywords: the text inserted or type by the user.
    private func getValidWordsCount(for keywords: String) -> Int {
        let wordsList = nlp.tokenizeByWords(keywords)
        let wordsInCorpus = wordsList.filter { Constants.thousandWords.contains($0)}
        return wordsInCorpus.count
    }
    
    
    /// Updates the color and accessibility (enable - disable) of the send botton but
    /// setting its status
    /// - Parameter isActive: the status that the button should adhere to
    private func updateSendButton(isActive: Bool) {
        switch isActive {
        case false:
            sendButton.tintColor = .lightGray
            sendButton.backgroundColor = .darkGray
            sendButton.isEnabled = false
        case true:
            sendButton.tintColor = FawGenColors.secondary.color
            sendButton.backgroundColor = FawGenColors.primary.color
            sendButton.isEnabled = true
        }
    }
}


// MARK: - Close Button

extension FilterViewController {
    /// Sets up the close Button and its attributes
    public func setupCloseButton() {
        closeButton.sizeToFit()
        closeButton.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        closeButton.frame = CGRect(x: view.bounds.width - 50, y: 20, width: 30, height: 30)
        view.addSubview(closeButton)
    }
    
    @objc private func tapCloseButton() {
        saveSteppersValues()
        keywordsTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}



// MARK: - Text Field Delegate
extension FilterViewController: UITextFieldDelegate {
    
    @objc private func editingChanged() {
        //print("[editingChanged]")
        guard let currentText = keywordsTextField.text else { return }
        guard let textCount = keywordsTextField.text?.count else { return }
        maxKeywordLengthChecker(for: textCount)
        currentText.count > 0 ? updateSendButton(isActive: true) : updateSendButton(isActive: false)
        let wordsInCorpusCount = getValidWordsCount(for: currentText)
        setWordsLevelMeter(for: wordsInCorpusCount)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        hasTappedSendForKeywords = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keywordsRequestSent()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else { return false }

        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        if count > keywordsMaxChars { maxKeywordLengthChecker(for: count) }
        return count <= keywordsMaxChars
    }
    
    /// Checks if the text entered (as paste or typed) exceeds the max length
    /// and display visula info to the user
    /// - Parameter length: the length to check as String
    private func maxKeywordLengthChecker(for length: Int) {
        if textLimitLabel.alpha != 1 { textLimitLabel.alpha = 1 }
        textLimitLabel.textColor = .white
        if length > keywordsMaxChars {
            textLimitLabel.text = "Too large: \(length)/\(keywordsMaxChars)"
            textLimitLabel.flashLimit()
        } else if length == 0 {
            if textLimitLabel.alpha != 0 { textLimitLabel.alpha = 0 }
        } else {
            textLimitLabel.stopAllRunningAnimations()
            guard let textCount = keywordsTextField.text?.count else { return }
            let leftChars = keywordsMaxChars - textCount
            textLimitLabel.text = "Left: \(leftChars)"
        }
    }
    
    
}

// MARK: - Keyboard Notification

extension FilterViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        keyboardFrame = keyboardSize.cgRectValue
        view.frame.origin.y -= keyboardFrame.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += keyboardFrame.height
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
        if hasTappedSendForKeywords {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}


// MARK: - History Keywords Description

extension FilterViewController {
    
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
    
    /// Sends the keyqords query for analyzing from the model
    public func keywordsRequestSent() {
        if let keywords = keywordsTextField.text { saveToHistory(keywords) }
        hasTappedSendForKeywords = true
        keywordsTextField.text = nil
        updateSendButton(isActive: false)
        keywordsTextField.resignFirstResponder()
    }
}
