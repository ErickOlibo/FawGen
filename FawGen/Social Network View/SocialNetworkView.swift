//
//  SocialNetworkView.swift
//  FawGen
//
//  Created by Erick Olibo on 29/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

class SocialNetworkView: UIView {

    // MARK: - Properties
    
    @IBOutlet weak var socialNetworkIcon: UIImageView!
    @IBOutlet weak var socialNetworkName: UILabel!
    
//    public enum AvailabilityStatus: String {
//        case normal
//        case available
//        case taken
//    }
//
//    public var currentStatus: AvailabilityStatus?
//
//    public var dominantColor: UIColor = .white
//
//    var icon: UIImage? {
//        get {
//            return socialNetworkIcon.image
//        }
//        set(icon) {
//            socialNetworkIcon.image = icon
//        }
//    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Public Helpers Methods
    
//    public func setAvalibility(_ status: AvailabilityStatus, socialMedia: SocialMedia) {
//
//        socialNetworkName.text = socialMedia.name
//        socialNetworkIcon.image = socialMedia.icon
//
//        switch status {
//        case .normal:
//            socialNetworkIcon.tintColor = .white
//            socialNetworkIcon.backgroundColor = socialMedia.color
//            socialNetworkName.textColor = .white
//
//        case .available:
//            socialNetworkIcon.tintColor = .white
//            socialNetworkIcon.backgroundColor = .green
//            socialNetworkName.textColor = .white
//
//        case .taken:
//            socialNetworkIcon.tintColor = .lightGray
//            socialNetworkIcon.backgroundColor = .darkGray
//            socialNetworkName.textColor = .lightGray
//        }
//        currentStatus = status
//
//    }
    
    // MARK: - Private Helpers Methods
    
    // Performs initial setup.
    private func setupView() {
        let view = Bundle.main.loadNibNamed("SocialNetworkView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        
        view.autoresizingMask = [
            UIView.AutoresizingMask.flexibleWidth,
            UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
//    // Loads a XIB file into a view and returns this view.
//    private func viewFromNib() -> UIView {
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
//        return view
//        
//    }
//    
//    /// Loads a XIB new try
//    private func newViewFromNib() -> UIView {
//        return Bundle.main.loadNibNamed("SocialNetworkView", owner: self, options: nil)?.first as! UIView
//    }
    
}
