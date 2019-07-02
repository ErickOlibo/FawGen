//
//  Colors.swift
//  FawGen
//
//  Created by Erick Olibo on 29/05/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit



extension String {
    
    /// Checks if a string is a valid HEX format
    /// - Note: The string can start with or without
    /// a hashtag (e.g. #00F43E)
    /// - Returns: A boolean to rather or not this format is HEX compatible
    private func isValidHexColor() -> Bool {
        let chars = CharacterSet(charactersIn: "#0123456789ABCDEF").inverted
        let charsNum = self.count
        guard charsNum == 6 || charsNum == 7 && self.hasPrefix("#") else { return false }
        
        if (charsNum == 6) && uppercased().rangeOfCharacter(from: chars) != nil { return false }
        if (charsNum == 7 && self.hasPrefix("#")) && uppercased().rangeOfCharacter(from: chars) != nil { return false }
        return true
    }
    
    /// Converts a color from the HEX format to the UIColor format
    /// - Note: This method checks for the validity of the string format
    /// as HEX color
    /// - Returns: UIColor from HEX format or clear color
    public func convertedToUIColor() -> UIColor {
        var color = self.uppercased()
        guard color.isValidHexColor() else { return .clear }
        
        // Remove the starting hashtag if any
        color = color.hasPrefix("#") ? String(color.dropFirst()) : color
        let red = String(color.prefix(2))
        color = String(color.dropFirst(2))
        let green = String(color.prefix(2))
        color = String(color.dropFirst(2))
        let blue = String(color.prefix(2))
        
        var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
        Scanner(string: red).scanHexInt32(&r)
        Scanner(string: green).scanHexInt32(&g)
        Scanner(string: blue).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(Float(r) / 255.0), green: CGFloat(Float(g) / 255.0), blue: CGFloat(Float(b) / 255.0), alpha: 1)
    }
}

extension UIColor {
    
    /// Converts a UIColor to HEX color as String
    /// There is hashtag added to the format
    public func convertedToHEXColor() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 1
        _ = self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%02X%02X%02X", Int(red * 0xff), Int(green * 0xff), Int(blue * 0xff))
    }
    
}

