//
//  SocialView.swift
//  FawGen
//
//  Created by Erick Olibo on 29/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


/// A UIView representing the icon, name and availability status
/// of a social network, display as a square
class SocialView: UIView {

    // MARK: - Properties
    public enum AvailabilityStatus: String {
        case normal
        case available
        case taken
    }
    
    public var currentStatus: AvailabilityStatus = .normal {
        didSet {
            updateAvailabilityUI()
        }
    }
    
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
    
    /// This method set the basic characteristics during the awake from NIB
    /// of the Social View
    private func commonInitialization() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight]
        
        // Set the constraints
        let viewCornerRadius = bounds.width * 0.1 // 20% of corner radius
        let ratio: CGFloat = bounds.width * 0.1 // 10% of the view width
        let heightRatio: CGFloat = bounds.width * 0.3 // 30% of the view width
        iconTopSpace.constant = ratio
        titleBottomSpace.constant = ratio
        titleTrailingSpace.constant = ratio
        titleLeadingSpace.constant = ratio
        titleHeightSize.constant = heightRatio
        
        view.addSubview(icon)
        view.addSubview(title)
        view.layer.cornerRadius = viewCornerRadius
        self.view = view
        self.addSubview(view)
    }
    
    /// Special Initialization with a SocialMedia type to add function
    /// to an already initialized Social View (via init(frame) )
    /// - Parameter info: this is the social network entity that will
    /// be core of this socialView.
    /// - Parameter status: Set the availability status of this entity.
    /// - Note: This method is overflown with a default status of .normal.
    public func initialize(_ info: SocialMedia, status: AvailabilityStatus = .normal) {
        
        self.socialInfo = info
        title.text = info.name
        icon.image = info.icon
        
        self.currentStatus = status
    }

    /// Updates the Availability status of the social view and updates the UI
    private func updateAvailabilityUI() {
        guard let info = socialInfo else { return }
        switch currentStatus {
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
        
    }


}
