//
//  CellDomainView.swift
//  FawGen
//
//  Created by Erick Olibo on 26/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

/// A UIView representing the domain extension text and availability status
/// of a domain, display as a rectangle of 8:5 ratio
class CellDomainView: UIView {

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
    
    private(set) var domainExt: DomainExtension = .com
    private(set) var view: UIView!
    
    // MARK: - Outlets
    @IBOutlet weak var extensionLabel: UILabel!
    
    
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
    /// of the Cell Domain View
    private func commonInitialization() {
        let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight]
        
        view.addSubview(extensionLabel)
        view.layer.cornerRadius = 5
        self.view = view
        self.addSubview(view)
    }
    
    /// Special Initialization with the domain extension to add more functions
    /// to the already initialized Domain View (via init(frame) )
    /// - Parameter info: this is the Domain Extension type that will
    /// be core to this CellDomainView.
    /// - Parameter status: Set the availability status of this entity.
    /// - Note: This method has a default Availability status of .normal
    public func initialize(_ info: DomainExtension, status: AvailabilityStatus = .normal) {
        let dot = "."
        extensionLabel.text = (info == .couk) ? ".co.uk" : dot + info.rawValue
        self.domainExt = info
        self.currentStatus = status
    }
    
    
    /// Updates the Availability status of the Cell Domain View and updates the UI
    private func updateAvailabilityUI() {
        switch currentStatus {
        case .normal:
            extensionLabel.textColor = .white
            view.backgroundColor = FawGenColors.secondary.color
            
        case .available:
            extensionLabel.textColor = .white
            view.backgroundColor = FawGenColors.availableStatus.color
        case .taken:
            extensionLabel.textColor = .gray
            view.backgroundColor = .darkGray
        }
    }

}
