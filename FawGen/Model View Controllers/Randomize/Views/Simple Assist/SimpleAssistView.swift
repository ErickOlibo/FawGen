//
//  SimpleAssistView.swift
//  FawGen
//
//  Created by Erick Olibo on 22/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class SimpleAssistView: UIView {
    
    // MARK: - Properties
    enum StackViewState: String {
        case open
        case close
    }
    
    public let openViewIndex: Int = 0
    public var textMaxLength: Int = 200
    public var state: StackViewState = .close { didSet { toggle() }}
    public let nlp = NaturalLanguageProcessor()
    public var currentWordsCount: Int = 0
    public var currentCorpusCount: Int = 0
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: - Top View
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var keywordsFrameView: UIView! { didSet { keywordsFrameSetup() } }
    
    //@IBOutlet weak var backOfTopView: UIView!
    @IBOutlet weak var keywordsGrowningTextView: GrowingTextView! { didSet { keywordsGrowningTextSetup() } }
    @IBOutlet weak var textLengthLabel: UILabel! { didSet { textLengthLabelSetup() } }

    // Bottom View
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var letsGoButton: UIButton! { didSet { letsGoButtonSetup() } }
    
    @IBOutlet weak var simpleButton: UIButton!
    @IBOutlet weak var assistButton: UIButton!
    
    
    // MARK: - Actions
    @IBAction func tappedSimple(_ sender: UIButton) {
        if keywordsGrowningTextView.isFirstResponder {
            keywordsGrowningTextView.resignFirstResponder()
        }
        sender.pulse()
        if state == .open { closeStack() } }

    @IBAction func tappedAssit(_ sender: UIButton) {
        sender.pulse()
        if state == .close { openStack() } }
    
    @IBAction func tappedLetsGo(_ sender: UIButton) {
        keywordsGrowningTextView.resignFirstResponder()
        state == .close ? letsGoSimple() : letsGoAssist()
    }
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("SimpleAssistView: Frame: \(frame)")
        commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
    }
 
}



