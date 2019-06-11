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
    public let closeButton = SPLarkSettingsCloseButton()
    public let nlp = NaturalLanguageProcessor()
    public let titleLabel = UILabel()
    public var onOffCollection = [OnOff : Bool]()
    public enum OnOff: String {
        case length, type, symbol
    }
    
    
    // MARK: - Outlets
    @IBOutlet weak var advancedLabel: UILabel!
    @IBOutlet weak var keywordsTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet var wordsLevelMeter: [UIView]!
    
    @IBOutlet weak var lengthStepper: TEOStepper!
    @IBOutlet weak var lengthOnOff: UIButton!
    @IBOutlet weak var typeStepper: TEOStepper!
    @IBOutlet weak var typeOnOff: UIButton!
    @IBOutlet weak var symbolStepper: TEOStepper!
    @IBOutlet weak var symbolOnOff: UIButton!
    
    
    // MARK: - Actions
    @IBAction func tappedSend(_ sender: UIButton) {
        sender.pulse()
        keywordsTextField.resignFirstResponder()
    }
    
    @IBAction func tappedLengthOnOff(_ sender: UIButton) {
        sender.pulse()
        print("Length is On - Off")
    }
    
    @IBAction func tappedTypeOnOff(_ sender: UIButton) {
        sender.pulse()
        print("Type is On - Off")
    }
    
    @IBAction func tappedSymbolOnOff(_ sender: UIButton) {
        sender.pulse()
        print("Symbol is On - Off")
    }
    

    // MARK: - ViewController LifeCycle
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation { return .slide }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        setupFilterUI()
        initDataBase()
    }
    
    // Dismiss keyboard at touch outside textField and inside filterVC
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        keywordsTextField.resignFirstResponder()
    }
    
    
 
}


// Updates all element of FilterVC UI
extension FilterViewController {
    private func setupFilterUI() {
        setupKeywordsUI()
        setupCloseButtonUI()
        setupSteppers()
        
    }
    
    
}



