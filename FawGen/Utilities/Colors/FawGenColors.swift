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
    /// Of tint color Orange, name code: Orioles Orange
    case primary
    /// Of tint color Blue, name code: Prussian Blue
    case secondary
    /// Of tint color Yellow, name code: UCLA Gold
    case tertiary
    /// Of tint color Green, name code: UFO Green
    case availableStatus
    /// Of tint color Orange, name code: Darker Orioles Orange
    case primaryDark
    /// Of tint very light gray, name code: Very Light Gray (for cell background)
    case cellGray
    
    
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
        case .primaryDark:
            return Colors.primaryDark.rawValue.convertedToUIColor()!
        case .cellGray:
            return Colors.cellGray.rawValue.convertedToUIColor()!
        }
    }
}


private enum Colors: String {
    case primary = "#F6511D" // Orioles Orange
    case secondary = "#0D2C54" // Prussian Blue
    case tertiary = "FFB400" // UCLA Gold
    case availableStatus = "3CD070" // UFO Green (for available Status)
    case primaryDark = "#BC3000" // Special darker Orange for Steppers
    case cellGray = "#EEEEEE" // Very Light gray color from the Design
}
