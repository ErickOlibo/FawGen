//
//  MySocialView.swift
//  FawGen
//
//  Created by Erick Olibo on 29/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class MySocialView: UIView {

    var icon: UIImageView!
    var name: UILabel!
    var socialColor: UIColor = .white {
        didSet {
            self.backgroundColor = socialColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
 
    /// Setting the view
    private func setupView() {
        print("Here: Size of frameBounds \(bounds) and Size: \(bounds.size)")
        
        let iconRatio: CGFloat = 0.5
        //let iconOtherRatio: CGFloat = 1 - iconRatio
        let nameRatio: CGFloat = 0.9
        
        let iconRatioToTrailing: CGFloat = (1 - iconRatio) / 2
        let iconSpaceToTop: CGFloat = 5
        let iconSize = CGSize(width: bounds.size.width * iconRatio, height: bounds.size.height * iconRatio)
        let iconOrigin = CGPoint(x: bounds.size.width * iconRatioToTrailing, y: iconSpaceToTop)
        icon = UIImageView(frame: CGRect(origin: iconOrigin, size: iconSize))
        
        let nameRatioToTrailing: CGFloat = (1 - nameRatio) / 2
        //let nameSpaceToBottom: CGFloat = 5
        let nameHeight: CGFloat = 20
        
        let nameSize = CGSize(width: bounds.size.width * nameRatio, height: nameHeight)
        let nameOriginY: CGFloat = bounds.size.height * iconRatio + 10
        let nameOrigin = CGPoint(x: bounds.size.width * nameRatioToTrailing, y: nameOriginY)
        name = UILabel(frame: CGRect(origin: nameOrigin, size: nameSize))
        
        print("Icon: \(icon.frame) - Name: \(name.frame)")
        // SETUP the text
        name.textAlignment = .center
        //name.font = UIFont.systemFont(ofSize: 20)
        name.numberOfLines = 1
        name.adjustsFontSizeToFitWidth = true
        
        
        // Set the default view as Facebook
        let facebook = SocialNetwork.facebook.info
        
        
        let tintedIcon = facebook.icon.withRenderingMode(.alwaysTemplate)
        icon.image = tintedIcon
        name.text = facebook.name
        


        name.textColor = .black
        icon.tintColor = .white
        
        self.backgroundColor = facebook.color
        
        self.addSubview(icon)
        self.addSubview(name)
        
        print("-> Icon: \(icon.frame) - Name: \(name.frame)")
    }

}
