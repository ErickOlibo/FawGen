//
//  FilterViewController.swift
//  FawGen
//
//  Created by Erick Olibo on 08/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    // MARK: - Properties
    public var keyboardFrame = CGRect()
    public let closeButton = SPLarkSettingsCloseButton()
    public let nlp = NaturalLanguageProcessor()
    public let titleLabel = UILabel()
//    public var onOffCollection = [OnOff : Bool]()
//    public enum OnOff: String {
//        case length, type, symbol
//    }
    public enum SettingCategory: Int, CaseIterable, Equatable, Hashable {
        case length = 1, type, symbol
    }
    
    
    // MARK: - Outlets & Outlets collection
    @IBOutlet weak var advancedLabel: UILabel!
    @IBOutlet weak var keywordsTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet var wordsLevelMeter: [UIView]!
    
    @IBOutlet var steppers: [TEOStepper]!
    @IBOutlet var onOffs: [UIButton]!
    
    
    // MARK: - Actions
    @IBAction func tappedSend(_ sender: UIButton) {
        sender.pulse()
        keywordsTextField.resignFirstResponder()
    }
    
    @IBAction func tappedOnOff(_ sender: UIButton) {
        sender.pulse()
        switchOnOff(for: sender)
        print("tapped OnOff for \(sender.tag)")
    }
    

    // MARK: - ViewController LifeCycle
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Register Notifications:
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.backgroundColor = .black
        setupDataBase()
        setupCloseButton()
        setupKeywords()
        setupSteppers()
        setupOnOffs()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveSteppersValues()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Dismiss keyboard at touch outside textField and inside filterVC
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        keywordsTextField.resignFirstResponder()
    }
    
    
 
}





