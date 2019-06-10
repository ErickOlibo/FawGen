//
//  FilterViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 08/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    

    
    
    // MARK: - Properties and Outlets
    private let closeButton = SPLarkSettingsCloseButton()
    private let nlp = NaturalLanguageProcessor()
    public let titleLabel = UILabel()
    @IBOutlet weak var advancedLabel: UILabel!
    @IBOutlet weak var keywordsTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var lengthStepper: TEOStepper!
    @IBOutlet weak var lengthOnOffButton: UIButton!
    
    
    
    
    // Collection for the words in corpus Level
    @IBOutlet var wordsLevelMeter: [UIView]!

    
    // MARK: - Actions
    @IBAction func tappedSend(_ sender: UIButton) {
        // More actions like Go to the Randomizer
        keywordsTextField.resignFirstResponder()
    }
    
    @IBAction func tappedLengthOnOff(_ sender: UIButton) {
        sender.pulse()
        print("Length is On - Off")
    }
    

    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keywordsTextField.delegate = self
        view.backgroundColor = .black
        advancedLabel.textColor = .white
        
        sendButton.layer.cornerRadius = sendButton.bounds.height / 2
        sendButton.setImage(UIImage(named: "sendSmall")?.withRenderingMode(.alwaysTemplate), for: .normal)
        updateSendButton(isActive: false)
        keywordsTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)

        setCloseButton()
        updateUI()
        setWordsLevelMeter()
        lengthStepperUI()
    }
    
    // Dismiss keyboard at touch outside textField and inside filterVC
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        keywordsTextField.resignFirstResponder()
    }
    
 
}

extension FilterViewController {
    
    // Set up the LengthStepper
    private func lengthStepperUI() {
        let collection: [Double : String] = [6 : "6 letters", 7 : "7 letters", 8 : "8 letters", 9 : "9 letters", 10 : "10 letters", 11 : "11 letters", 12 : "12 letters", 13 : "13 letters", 14 : "14 letters", 15 : "15 letters", 16 : "16 letters" ]
        lengthStepper.textCollection = collection
        lengthStepper.value = 8
        lengthStepper.minimumValue = 6
        lengthStepper.maximumValue = 16
        lengthStepper.labelWidthWeight = 0.5
        lengthStepper.labelSlideLength = 20
        
    }
    
    // Set the wordLevelMeter
    private func setWordsLevelMeter(for count: Int = 0) {
        for levelView in wordsLevelMeter {
            if levelView.tag <= count {
                levelView.backgroundColor = FawGenColors.primary.color
            } else {
                levelView.backgroundColor = .darkGray
            }
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
    
    
    private func updateUI() {
        setCloseButton()
        
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
    
    private func setCloseButton() {
        // Setup Button
        closeButton.sizeToFit()
        closeButton.addTarget(self, action: #selector(tapCloseButton), for: .touchUpInside)
        closeButton.frame = CGRect(x: view.bounds.width - 50, y: 20, width: 30, height: 30)
        view.addSubview(closeButton)
        //print("Label: \(titleLabel.bounds) - Close: \(closeButton.bounds)")
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
