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
    private let openViewIndex: Int = 0
    var state: StackViewState = .close { didSet { toggle() }}
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: UIStackView!
    
    // MARK: - Top View
    @IBOutlet weak var topView: UIView!
    //@IBOutlet weak var backOfTopView: UIView!
    @IBOutlet weak var keywordsGrowningTextView: GrowingTextView!
    //@IBOutlet weak var textLengthLabel: UILabel!

    // Bottom View
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var letsGoButton: UIButton!
    @IBOutlet weak var simpleButton: UIButton!
    @IBOutlet weak var assistButton: UIButton!
    
    
    // MARK: - Actions
    @IBAction func tappedSimple(_ sender: UIButton) {
        print("Tapped Simple")
        sender.pulse()
        if state == .open {
            closeStack()
        }
        //state == .close ? openStack() : closeStack()

    }

    @IBAction func tappedAssit(_ sender: UIButton) {
        print("Tapped Assist")
        sender.pulse()
        if state == .close {
            openStack()
        }
        //state == .close ? openStack() : closeStack()

    }
    
    @IBAction func tappedLetsGo(_ sender: UIButton) {
        print("Let's Go")
        //state == .close ? openStack() : closeStack()
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
    
    private func commonInitialization() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        print("View bundle: \(view.bounds)")
        print("Bounds: \(bounds)")
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight]
        self.addSubview(view)
        state = .close
        
    }
    
    // MARK: - Methods
    
    private func closeStack() {
        print("Close Stack")
        topView.alpha = 1
        UIView.animate(withDuration: 0.3) {
            self.topView.alpha = 0
        }
        state = .close
    }
    
    private func openStack() {
        print("Open Stack")
        topView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.topView.alpha = 1
        }
        state = .open
        
    }
    
    private func toggle() {
        print("Toggled() --> State is: \(state.rawValue)")
        stackView.arrangedSubviews[openViewIndex].isHidden = isStateClosed()
        
    }
    
    private func isStateClosed() -> Bool {
        return state == .close
        }

}
