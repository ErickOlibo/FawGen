//
//  DeviceScreenSizes.swift
//  FawGen
//
//  Created by Erick Olibo on 11/06/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension UIDevice {
    
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
