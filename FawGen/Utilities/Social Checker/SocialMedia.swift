//
//  SocialNetwork.swift
//  FawGen
//
//  Created by Erick Olibo on 29/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

/// A structure and data type that carries the icon (logo)
/// the name and the dominant color of a social Network
/// - Remark: Use the SocialChecker enum SocialNetwork to access
/// this data for a particular social Network:
/// (e.g. SocialNetwork.facebook.info)
public struct SocialMedia: CustomStringConvertible {
    
    private(set) var icon: UIImage
    private(set) var name: String
    private(set) var color: UIColor
    
    init(_ name: String, icon: UIImage, color: UIColor) {
        self.name = name.brandified()
        self.icon = icon.withRenderingMode(.alwaysTemplate)
        self.color = color
    }
    
    public var description: String {
        return "\(name)"
    }
}


extension String {
    
    /// Returns the right way to write the trademark
    /// with UpperCase Letters when needed
    fileprivate func brandified() -> String {
        switch self {
        case SocialNetwork.angellist.rawValue:
            return "AngelList"
        case SocialNetwork.bitbucket.rawValue:
            return "BitBucket"
        case SocialNetwork.producthunt.rawValue:
            return "Prod. Hunt"
        case SocialNetwork.youtube.rawValue:
            return "YouTube"
        default:
            return self.capitalized
        }
    }
}
