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
        case unknown
    }
    
    public var status: AvailabilityStatus = .normal {
        didSet {
            updateAvailabilityUI()
        }
    }
    
    private(set) var socialInfo: SocialMedia?
    
    
    // MARK: - Outlets

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconBackView: UIView!

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
        iconBackView.layer.cornerRadius = 5.0
        
        //view.addSubview(icon)
        //view.addSubview(title)
        //view.addSubview(iconBackView)
        
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
        
        self.status = status
    }

    /// Updates the Availability status of the social view and updates the UI
    private func updateAvailabilityUI() {
        guard let info = socialInfo else { return }
        switch status {
        case .normal:
            title.textColor = FawGenColors.secondary.color
            icon.tintColor = .white
            //icon.backgroundColor = info.color
            iconBackView.backgroundColor = info.color
            
        case .available:
            title.textColor = FawGenColors.secondary.color
            icon.tintColor = .white
            //icon.backgroundColor = FawGenColors.availableStatus.color
            iconBackView.backgroundColor = FawGenColors.availableStatus.color
            
        case .taken:
            title.textColor = .gray
            icon.tintColor = .gray
            //icon.backgroundColor = .darkGray
            iconBackView.backgroundColor = .darkGray
        case .unknown:
            title.textColor = FawGenColors.secondary.color
            icon.tintColor = .white
            iconBackView.backgroundColor = FawGenColors.unknown.color
        }
        
    }


}
