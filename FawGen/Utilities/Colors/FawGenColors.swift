//
//  FawGenColors.swift
//  FawGen
//
//  Created by Erick Olibo on 31/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

/// This is an enumeration of the list of constant colors used and available
/// in this the FawGen app.
///  - Note: The primary, secondary, tertiary colors are from FawGen logomark
/// availableStatus is the in-app visual color for available domains and handles
public enum FawGenColors: String, CustomStringConvertible, CaseIterable, Equatable, Hashable {
    case primary, secondary, tertiary, availableStatus
    
    
    
    public var description: String {
        return self.rawValue
    }
    
    /// returns the FawGen constant colors as UIColor
    public var color: UIColor {
        switch self {
        case .primary:
            return Colors.primary.rawValue.convertedToUIColor()!
        case .secondary:
            return Colors.secondary.rawValue.convertedToUIColor()!
        case .tertiary:
            return Colors.tertiary.rawValue.convertedToUIColor()!
        case .availableStatus:
            return Colors.availableStatus.rawValue.convertedToUIColor()!
        }
    }
}


private enum Colors: String {
    case primary = "#F6511D" // Orioles Orange
    case secondary = "#0D2C54" // Prussian Blue
    case tertiary = "FFB400" // UCLA Gold
    case availableStatus = "3CD070" // UFO Green (for available Status
}