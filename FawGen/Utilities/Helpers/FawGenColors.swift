//
//  FawGenColors.swift
//  FawGen
//
//  Created by Erick Olibo on 31/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

public enum FawGenColors: String, CustomStringConvertible, CaseIterable, Equatable, Hashable {
    case primary, secondary, tertiary
    
    
    
    public var description: String {
        return self.rawValue
    }
    
    public var color: UIColor {
        switch self {
        case .primary:
            print("this")
            return Colors.primary.rawValue.convertedToUIColor()!
        case .secondary:
            return Colors.secondary.rawValue.convertedToUIColor()!
        case .tertiary:
            return Colors.tertiary.rawValue.convertedToUIColor()!
        }
    }
}


private enum Colors: String {
    case primary = "#F6511D" // Orioles Orange
    case secondary = "#0D2C54" // Prussian Blue
    case tertiary = "FFB400" // UCLA Gold
}
