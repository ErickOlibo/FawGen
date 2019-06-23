//
//  SimpleAssistView.swift
//  FawGen
//
//  Created by Erick Olibo on 22/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class SimpleAssistView: UIView {
    
    enum RandomState {
        case assit
        case simple

    }
    
    // MARK: - Outlets
    @IBOutlet weak var stackView: UIStackView!
    
    // Top View
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var keywordsView: UIView!
    @IBOutlet weak var keywordsTextView: GrowingTextView!
    @IBOutlet weak var textLengthLabel: UILabel!
    
    // Bottom View
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var letsGoButton: UIButton!
    @IBOutlet weak var singleButton: UIButton!
    @IBOutlet weak var assistButton: UIButton!
    
    

    // MARK: - Properties
    
    
    
    

    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
        
    }
    

}
