//
//  SocialNetwork.swift
//  FawGen
//
//  Created by Erick Olibo on 29/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit


public struct SocialMedia: CustomStringConvertible {
    
    private(set) var icon: UIImage
    private(set) var name: String
    private(set) var color: UIColor
    
    init(_ name: String, icon: UIImage, color: UIColor) {
        self.name = name.brandified()
        self.icon = icon
        self.color = color
    }
    
    public var description: String {
        return "\(name)"
    }
    

    
}


extension String {
    
    /// Returns the write way to write the trademark
    /// with UpperCase Letters when needed
    fileprivate func brandified() -> String {
        switch self {
        case SocialNetwork.angellist.rawValue:
            return "AngelList"
        case SocialNetwork.bitbucket.rawValue:
            return "BitBucket"
        case SocialNetwork.producthunt.rawValue:
            return "ProductHunt"
        case SocialNetwork.youtube.rawValue:
            return "YouTube"
        default:
            return self.capitalized
        }
    }
}
