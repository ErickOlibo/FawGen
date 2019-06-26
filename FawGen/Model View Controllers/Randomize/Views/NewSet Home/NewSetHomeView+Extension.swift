//
//  NewSetHomeView+Extension.swift
//  FawGen
//
//  Created by Erick Olibo on 26/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension NewSetHomeView {

    /// Initializes the basic setup nedded for the view
    /// to display properly
    public func commonInitialization() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight]
        view.backgroundColor = FawGenColors.cellGray.color
        self.addSubview(view)
    }
    
    /// Sets the necessary UI
    public func setupUI() {
        containerView.backgroundColor = .clear
        //homeButton.setTitleColor(FawGenColors.secondary.color, for: .normal)
        homeButton.setTitleColor(FawGenColors.primary.color)
        newSetButton.setTitleColor(FawGenColors.primary.color)
        
    }

    
}
