//
//  SocialView.swift
//  FawGen
//
//  Created by Erick Olibo on 29/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class SocialView: UIView {

    
    // MARK: - Outlets

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var iconTopSpace: NSLayoutConstraint!
    @IBOutlet weak var titleBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var titleTrailingSpace: NSLayoutConstraint!
    @IBOutlet weak var titleLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var titleHeightSize: NSLayoutConstraint!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
    }
    
    func commonInitialization() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        print("View Bounds: \(bounds)")
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight]
        
        // Set the constraints
        let viewWidth = bounds.width
        let ratio: CGFloat = viewWidth * 0.1 // 10% of the view width
        let heightRatio: CGFloat = viewWidth * 0.3 // 30% of the view width
        iconTopSpace.constant = ratio
        titleBottomSpace.constant = ratio
        titleTrailingSpace.constant = ratio
        titleLeadingSpace.constant = ratio
        titleHeightSize.constant = heightRatio
        
        
        // Setting default social info
        let socialInfo = SocialNetwork.pinterest.info
        title.text = socialInfo.name
        icon.image = socialInfo.icon.withRenderingMode(.alwaysTemplate)
        
        title.textColor = .white
        icon.tintColor = .white
        icon.backgroundColor = socialInfo.color
        view.backgroundColor = socialInfo.color
        view.addSubview(icon)
        view.addSubview(title)
        
        self.addSubview(view)
    }

}
