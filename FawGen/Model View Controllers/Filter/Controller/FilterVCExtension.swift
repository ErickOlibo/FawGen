//
//  FilterVCExtension.swift
//  FawGen
//
//  Created by Erick Olibo on 09/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


// ************************************** STEPPERS ***************************************

// Extension for the three steppers (Length, Type, Symbol)
extension FilterViewController {
    
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
    
    private func getStepper(for category: SettingCategory) -> TEOStepper {
        return steppers.filter{ $0.tag == category.rawValue }[0]
    }
    
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
    
//    private func setupLengthStepper() {
//        let collection = getStepperCollection(for: 1)
//        let stepper = getStepper(with: 1)
//        stepper.textCollection = collection
//        stepper.value = DefaultDB.getValue(for: .length)! as Double
//        stepper.minimumValue = 6
//        stepper.maximumValue = 16
//
//
//        enabledStatus(for: stepper)
//    }
    
//    private func realSetupAllSteppers() {
//        for category in SettingCategory.allCases {
//            let collection = getStepperCollection(for: category)
//            let minMax = getStepperMinMaxValue(for: category)
//            let stepper = getStepper(for: category)
//            stepper.textCollection = collection
//            stepper.minimumValue = minMax[0]
//            stepper.maximumValue = minMax[1]
//            switch category {
//            case .length:
//                stepper.value = DefaultDB.getValue(for: .length)! as Double
//            case .type:
//                stepper.value = DefaultDB.getValue(for: .type)! as Double
//            case .symbol:
//                stepper.value = DefaultDB.getValue(for: .symbol)! as Double
//            }
//            enabledStatus(for: stepper)
//        }
//    }
    
//    private func setupTypeStepper() {
//        let collection: [Double : String] = [1 : "alpha", 2 : "beta", 3 : "gamma", 4 : "delta", 5 : "epsilon", 6 : "zeta"]
//        let stepper = getStepper(with: 2)
//        stepper.textCollection = collection
//        stepper.value = DefaultDB.getValue(for: .type)! as Double
//        stepper.minimumValue = 1
//        stepper.maximumValue = 6
//        enabledStatus(for: stepper)
//    }
//
//
//    private func setupSymbolStepper() {
//        let collection: [Double : String] = [1 : "popular", 2 : "common", 3 : "average", 4 : "uncommon", 5 : "rare"]
//        let stepper = getStepper(with: 3)
//        stepper.textCollection = collection
//        stepper.value = DefaultDB.getValue(for: .symbol)! as Double
//        stepper.minimumValue = 1
//        stepper.maximumValue = 5
//        enabledStatus(for: stepper)
//    }
//
    

    
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

    
    
 
}

// ************************************** ON OFF TAP ***************************************

// Extension for the handling of OnOff tapp
extension FilterViewController {
    
    public func setupOnOffs() {
        for category in SettingCategory.allCases {
            setupOnOff(for: category)
        }
        
    }
    
//    // Setting all buttons with the default (all false) or the saved
//    // (via userDefault) states
//    public func setupOnOffUI() {
//        // Recall from UserDefaults
//        let status = currentOnOffStatus(for: lengthOnOff)
//        updateOnOffUI(for: lengthOnOff, with: status)
//
//
//    }
    
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
        //button.contentHorizontalAlignment = .center
        //button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let status = currentOnOffStatus(for: button)
        updateOnOff(for: button, with: status)
    }
    
    private func getOnOffButton(for category: SettingCategory) -> UIButton {
        return onOffs.filter{ $0.tag == category.rawValue }[0]
    }
    
    
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
    
    
    private func onOfftext(for sender: UIButton) -> String {
        let onOffLabels = ["Length\n", "Type\n", "Symbol\n"]
        return onOffLabels[sender.tag - 1]
    }
    
    
    private func updateOnOff(for sender: UIButton, with status: Bool) {
        // set the text inside the OnOFf button
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
            sender.titleLabel?.textColor = .lightGray
            sender.backgroundColor = .darkGray
        }
        
    }
    
    private func addBoldText(fullString: NSString, boldPartOfString: NSString, font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
        let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
        let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
        let boldString = NSMutableAttributedString(string: fullString as String, attributes:nonBoldFontAttribute)
        boldString.addAttributes(boldFontAttribute, range: fullString.range(of: boldPartOfString as String))
        return boldString
    }
    
    
}


// ************************************** USER DATABASE ***************************************

// Extension for the UserDefaults initial state.
// Should only be initialized at the first time FilterVC
// is loaded.
extension FilterViewController {
    
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


// ************************************** KEYWORDS DESCRIPTION ***************************************

// Extension for the Keywords / Description textField
extension FilterViewController {
    
    public func setupKeywords() {
        keywordsTextField.delegate = self
        advancedLabel.textColor = .white
        sendButton.layer.cornerRadius = sendButton.bounds.height / 2
        sendButton.setImage(UIImage(named: "sendSmall")?.withRenderingMode(.alwaysTemplate), for: .normal)
        updateSendButton(isActive: false)
        keywordsTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        setWordsLevelMeter()
    }
    
    private func setWordsLevelMeter(for count: Int = 0) {
        for levelView in wordsLevelMeter {
            levelView.backgroundColor = levelView.tag <= count ? FawGenColors.primary.color : .darkGray
//            if levelView.tag <= count {
//                levelView.backgroundColor = FawGenColors.primary.color
//            } else {
//                levelView.backgroundColor = .darkGray
//            }
        }
    }
    
    @objc private func editingChanged() {
        guard let currentText = keywordsTextField.text else { return }
        currentText.count > 0 ? updateSendButton(isActive: true) : updateSendButton(isActive: false)
        let wordsInCorpusCount = getValidWordsCount(for: currentText)
        setWordsLevelMeter(for: wordsInCorpusCount)
    }
    
    private func getValidWordsCount(for keywords: String) -> Int {
        let wordsList = nlp.tokenizeByWords(keywords)
        let wordsInCorpus = wordsList.filter { Constants.thousandWords.contains($0)}
        return wordsInCorpus.count
    }
    
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
    
    private func setKeywordsText () {
        var keywordsFrame = keywordsTextField.frame
        keywordsFrame.size.height = 53
        keywordsTextField.frame = keywordsFrame
    }
    
    
    
}


// ************************************** CLOSE BUTTON ***************************************
// Extension for the close button
extension FilterViewController {
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



// ************************************** TEXT FIELD DELEGATE ***************************************

extension FilterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        //print("Text is been clear")
        updateSendButton(isActive: false)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //        let text = textField.text ?? "NIL"
        //        print("Text did Begin Editing: \(text)")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        let text = textField.text ?? "NIL"
        //        print("Text did end Editing: \(text)")
    }
}
