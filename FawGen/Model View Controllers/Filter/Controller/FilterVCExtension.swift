//
//  FilterVCExtension.swift
//  FawGen
//
//  Created by Erick Olibo on 09/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


// Extension for the three steppers (Length, Type, Symbol)
extension FilterViewController {
    
    public func setupSteppers() {
        setupLengthStepper()
    }
    
    private func setupLengthStepper() {
        let collection: [Double : String] = [6 : "6 letters", 7 : "7 letters", 8 : "8 letters", 9 : "9 letters", 10 : "10 letters", 11 : "11 letters", 12 : "12 letters", 13 : "13 letters", 14 : "14 letters", 15 : "15 letters", 16 : "16 letters" ]
        lengthStepper.textCollection = collection
        lengthStepper.value = 8
        lengthStepper.minimumValue = 6
        lengthStepper.maximumValue = 16
        lengthStepper.labelWidthWeight = 0.5
        lengthStepper.labelSlideLength = 20
         
        // Set the colors after
        
    }
    
    private func setupTypeStepper() {
        let collection: [Double : String] = [1 : "alpha", 2 : "beta", 3 : "gamma", 4 : "delta", 5 : "epsilon", 6 : "zeta"]
        lengthStepper.textCollection = collection
        lengthStepper.value = 3
        lengthStepper.minimumValue = 1
        lengthStepper.maximumValue = 6
        lengthStepper.labelWidthWeight = 0.5
        lengthStepper.labelSlideLength = 20
        
        // set the color
        
        
    }
    
    
    private func setupSymbolStepper() {
        let collection: [Double : String] = [1 : "popular", 2 : "common", 3 : "average", 4 : "uncommon", 5 : "rare"]
        lengthStepper.textCollection = collection
        lengthStepper.value = 3
        lengthStepper.minimumValue = 1
        lengthStepper.maximumValue = 5
        lengthStepper.labelWidthWeight = 0.5
        lengthStepper.labelSlideLength = 20
        
        // set the color
    }
}


// Extension for the handling of OnOff tapp
extension FilterViewController {
    
    // Setting all buttons with the default (all false) or the saved
    // (via userDefault) states
    public func setupOnOffUI() {
        
        
    }
    
    public func updateOnOffUI(for button: OnOff) {
        
        
    }
    
    
}

// Extension for the UserDefaults initial state.
// Should only be initialized at the first time FilterVC
// is loaded.
extension FilterViewController {
    
    public func initDataBase() {
        
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
        
        if DefaultDB.getValue(for: .SymbolOnOff)! as Bool? == nil {
            DefaultDB.save(false, for: .SymbolOnOff)
        }
    }
    
    
}



// Extension for the Keywords / Description textField
extension FilterViewController {
    
    public func setupKeywordsUI() {
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

// Extension for the close button
extension FilterViewController {
    public func setupCloseButtonUI() {
        closeButton.sizeToFit()
        closeButton.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        closeButton.frame = CGRect(x: view.bounds.width - 50, y: 20, width: 30, height: 30)
        view.addSubview(closeButton)
    }
    
    @objc private func tapCloseButton() {
        keywordsTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
}




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
