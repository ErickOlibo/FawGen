//
//  SocialView.swift
//  FawGen
//
//  Created by Erick Olibo on 29/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class SocialView: UIView {

    // MARK: - Properties
    public enum AvailabilityStatus: String {
        case normal
        case available
        case taken
    }
    
    public var currentStatus: AvailabilityStatus = .normal
    
    private(set) var socialInfo: SocialMedia?
    
    
    // MARK: - Outlets

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var iconTopSpace: NSLayoutConstraint!
    @IBOutlet weak var titleBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var titleTrailingSpace: NSLayoutConstraint!
    @IBOutlet weak var titleLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var titleHeightSize: NSLayoutConstraint!
    private(set) var view: UIView!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
    }
    
    private func commonInitialization() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        //print("View Bounds: \(bounds)")
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
        
        view.addSubview(icon)
        view.addSubview(title)
        self.view = view
        self.addSubview(view)
    }
    
    // Special Initialization with a SocialMedia type
    public func initialize(_ info: SocialMedia, status: AvailabilityStatus) {
        
        self.socialInfo = info
        title.text = info.name
        icon.image = info.icon.withRenderingMode(.alwaysTemplate)
        
        setAvailability(status)
    }
    
    // Set the availability
    public func setAvailability(_ status: AvailabilityStatus) {
        guard let info = socialInfo else { return }
        switch status {
        case .normal:
            title.textColor = .white
            icon.tintColor = .white
            icon.backgroundColor = info.color
            view.backgroundColor = info.color
            
        case .available:
            title.textColor = .white
            icon.tintColor = .white
            icon.backgroundColor = .green
            view.backgroundColor = .green
            
        case .taken:
            title.textColor = .gray
            icon.tintColor = .gray
            icon.backgroundColor = .darkGray
            view.backgroundColor = .darkGray
        }
        
        self.currentStatus = status
    }


}
