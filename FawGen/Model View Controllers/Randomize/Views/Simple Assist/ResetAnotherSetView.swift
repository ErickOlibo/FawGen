//
//  ResetAnotherSetView.swift
//  FawGen
//
//  Created by Erick Olibo on 22/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class ResetAnotherSetView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
        
    }
    
    
    
    private func commonInitialization() {
//        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
//        view.backgroundColor = .green
        
        
    }

}
