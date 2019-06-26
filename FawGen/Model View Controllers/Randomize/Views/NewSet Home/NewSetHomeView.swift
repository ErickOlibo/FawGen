//
//  NewSetHomeView.swift
//  FawGen
//
//  Created by Erick Olibo on 22/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class NewSetHomeView: UIView {

    // MARK: - Properties
    var newSetHomeDelegate: NewSetHomeDelegate?

    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var newSetButton: UIButton!
    
    
    // MARK: - Actions
    @IBAction func tappedHome(_ sender: UIButton) {
        print("Tapped HOME")
        newSetHomeDelegate?.showSimpleAssist()
    }
    
    
    @IBAction func tappedNewSet(_ sender: UIButton) {
        print("Tapped NEW SET")
        newSetHomeDelegate?.queryNewSetFromSimpleModel()
    }
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
        setupUI()
    }
    
    
    
    
}



