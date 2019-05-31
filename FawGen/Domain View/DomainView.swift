//
//  DomainView.swift
//  FawGen
//
//  Created by Erick Olibo on 30/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class DomainView: UIView {

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
    
    // MARK: - Outlets

    @IBOutlet weak var extensionLabel: UILabel!
    @IBOutlet weak var extensionTrailingSpace: NSLayoutConstraint!
    @IBOutlet weak var extensionLeadingSpace: NSLayoutConstraint!
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
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight]
        
        // Set Constraints
        let viewWidth = bounds.width
        let viewCornerRadius = viewWidth * 0.2 // 20% of corner radius
        let ratio: CGFloat = viewWidth * 0.1 // 10% of the view width
        extensionLeadingSpace.constant = ratio
        extensionTrailingSpace.constant = ratio
        view.addSubview(extensionLabel)
        view.layer.cornerRadius = viewCornerRadius
        self.view = view
        self.addSubview(view)
    }
    
    
    public func initialize(_ info: DomainExtension, status: AvailabilityStatus = .normal) {
        
        extensionLabel.text = (info == .couk) ? ".co.uk" : info.rawValue
        self.domainExt = info
        self.currentStatus = status
    }
    
    
    private func updateAvailabilityUI() {
        switch currentStatus {
        case .normal:
            extensionLabel.textColor = .black
            view.backgroundColor = .white
        case .available:
            extensionLabel.textColor = .white
            view.backgroundColor = .green
        case .taken:
            extensionLabel.textColor = .gray
            view.backgroundColor = .darkGray
        }
    }
    
    
}
