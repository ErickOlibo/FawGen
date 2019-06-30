//
//  DeviceScreenSizes.swift
//  FawGen
//
//  Created by Erick Olibo on 11/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension UIDevice {
    
    /// Gets the name of the device used with respect of the bounds height
    /// of the screen. It's a good indication of what device is used
    /// - Note: The Device model cannot be used in a distribution App as it
    /// would trigger and flag during the App store release process. i.e:
    /// Apple will reject the app
    public func currentPhoneHeightName() -> (CGFloat, String) {
        let height = UIScreen.main.nativeBounds.height
        var name = "UNDETERMINED"
        if userInterfaceIdiom == .phone {
            switch  height{
            case 1136:
                name = "IPHONE 5,5S,5C"
            case 1334:
                name = "IPHONE 6,7,8 IPHONE 6S,7S,8S"
            case 1920:
                name = "IPHONE 6PLUS, 6SPLUS"
            case 2208:
                name = "IPHONE 7PLUS, 8PLUS"
            case 2436:
                name = "IPHONE X, IPHONE XS"
            case 2688:
                name = "IPHONE XS_MAX"
            case 1792:
                name = "IPHONE XR"
            default:
                break
            }
        }
        
        return (height, name)
    }
    
    /// Detect the sare area bottom present in the iPhone X (Xs, Xs max)
    /// models.
    public func hasSafeAreaBottomHeight() -> Bool {
        let (currentHeight, _) = currentPhoneHeightName()
        switch currentHeight {
        case 2436, 2688, 1792:
            return true
        default:
            return false
        }
    }
    
    public func safeAreaBottomHeight() -> CGFloat {
        return hasSafeAreaBottomHeight() ? CGFloat(34.0) : CGFloat(0.0)
    }

}

extension CGFloat {
    
    /// splits a size in smaller pieces to accomodate a favorite viewWidth
    /// to fill up the screen width
    private func splitToSpacing(size: CGFloat, favWidth: CGFloat) -> [CGFloat] {
        let minSpacing: CGFloat = 10
        var leftSpace: CGFloat = 0
        var viewSpace: CGFloat = 0
        var rightSpace: CGFloat = 0
        let remainder = size - favWidth * 5
        let avgSpace = remainder / 6
        if avgSpace < minSpacing {
            return splitToSpacing(size: size, favWidth: favWidth - 1.0)
        } else {
            if  avgSpace.truncatingRemainder(dividingBy: 1) == 0 {
                leftSpace = avgSpace
                viewSpace = avgSpace
                rightSpace = avgSpace
                return [favWidth, leftSpace, viewSpace, rightSpace]
            } else {
                let floorAvg = avgSpace.rounded(.down)
                viewSpace = floorAvg
                let spaceRemainder = remainder -  (viewSpace * 4)
                leftSpace = (spaceRemainder / 2).rounded(.up)
                rightSpace = (spaceRemainder / 2).rounded(.down)
                return [favWidth, leftSpace, viewSpace, rightSpace]
            }
        }
    }
    
    /// Splits the CGFlot to an array of CGFloat to use in the
    /// representation of the Domain and Social Views.
    /// The 'self' is supposed to be the width of the view or
    /// device screen
    public var splitsSpacing: [CGFloat] {
        return splitToSpacing(size: self, favWidth: 60)
    }
}
