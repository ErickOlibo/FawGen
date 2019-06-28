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
/// - ToDo: Make sure that all constant colors are defined here, even if you use
/// the system default. Just to assure consstency across the App
public enum FawGenColors: String, CustomStringConvertible, CaseIterable, Equatable, Hashable {
    /// Of tint color Orange, The main color from the FawGen logo
    /// Code Name: Orioles Orange
    case primary
    
    /// Of tint color Blue, The second colo from the FawGen logo
    /// Code Name: Prussian Blue
    case secondary
    
    /// Of tint color Yellow, the smallest color from the FawGen logo
    /// Code Name: UCLA Gold
    case tertiary
    
    /// Of tint color Green, Represent the availabilty tint for Domain/social views
    /// Code Name: UFO Green
    case availableStatus
    
    /// Of tint color Orange, used for the Steppers in the FilterViewController
    /// to show the + and - keys.
    /// Code Name: Darker Orioles Orange
    case primaryDark
    
    /// Of tint very light gray, used for the RandomizeCell as background
    /// Code Name: Very Light Gray (for cell background)
    case cellGray
    
    /// Of tint color red, used for the unknown state from a URL request
    /// to check the availability of either Domain or Social sites
    /// Code Name: Alizarin Crimson
    case unknown
    
    
    public var description: String {
        return self.rawValue
    }
    
    /// returns the FawGen App Colors for consistency concern
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
        case .unknown:
            return Colors.unknown.rawValue.convertedToUIColor()!
        }
    }
}


/// The list of Fawgen App colors as Hex String
private enum Colors: String {
    case primary = "#F6511D" // Orioles Orange
    case secondary = "#0D2C54" // Prussian Blue
    case tertiary = "FFB400" // UCLA Gold
    case availableStatus = "3CD070" // UFO Green (for available Status)
    case primaryDark = "#BC3000" // Special darker Orange for Steppers
    case cellGray = "#EEEEEE" // Very Light gray color from the Design
    case unknown = "#E32636" // Alizarin Crimson
}
