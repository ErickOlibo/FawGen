//
//  CellSocialView.swift
//  FawGen
//
//  Created by Erick Olibo on 26/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


/// A UIView representing the icon, name and availability status
/// of a social network, display as a square
class CellSocialView: UIView {
    
    // MARK: - Properties
    private(set) var view: UIView!
    public enum AvailabilityStatus: String {
        case normal
        case available
        case taken
    }
    
    public var status: AvailabilityStatus = .normal {
        didSet {
            updateAvailabilityUI()
        }
    }
    
    private(set) var socialInfo: SocialMedia?
    
    
    // MARK: - Outlets
    @IBOutlet weak var icon: UIImageView!
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInitialization()
    }
    
    /// This method set the basic characteristics during the awake from NIB
    /// of the Cell Social View
    private func commonInitialization() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight]
        
        view.addSubview(icon)
        view.layer.cornerRadius = 5.0
        self.view = view
        self.addSubview(view)
        
    }
    
    /// Special Initialization with a SocialMedia type to add function
    /// to an already initialized Cell Social View (via init(frame))
    /// - Parameter info: this is the social network entity that will
    /// be core of this CellSocialView.
    /// - Parameter status: Set the availability status of this entity.
    /// - Note: This method has a default availability status of .normal.
    public func initialize(_ info: SocialMedia, status: AvailabilityStatus = .normal) {
        self.socialInfo = info
        icon.image = info.icon
        self.status = status
    }
    
    /// Updates the Availability status of the social view and updates the UI
    private func updateAvailabilityUI() {
        guard let info = socialInfo else { return }
        switch status {
        case .normal:
            icon.tintColor = .white
            icon.backgroundColor = info.color
            view.backgroundColor = info.color
            
        case .available:
            icon.tintColor = .white
            icon.backgroundColor = FawGenColors.availableStatus.color
            view.backgroundColor = FawGenColors.availableStatus.color
            
        case .taken:
            icon.tintColor = .gray
            icon.backgroundColor = .darkGray
            view.backgroundColor = .darkGray
        }
        
    }
    
}
