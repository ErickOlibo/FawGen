//
//  UIDeviceExtensions.swift
//  ModelForFawGen
//
//  Created by Erick Olibo on 28/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import UIKit

extension UIDevice {
    
    var modelName: DeviceModelName {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    
        switch identifier {
        case "iPhone6,1", "iPhone6,2":                  return .iPhone5s
        case "iPhone7,2":                               return .iPhone6
        case "iPhone7,1":                               return .iPhone6Plus
            
        case "iPhone8,1":                               return .iPhone6s
        case "iPhone8,2":                               return .iPhone6sPlus
        case "iPhone8,4":                               return .iPhoneSE
            
        case "iPhone9,1", "iPhone9,3":                  return .iPhone7
        case "iPhone9,2", "iPhone9,4":                  return .iPhone7Plus
        case "iPhone10,1", "iPhone10,4":                return .iPhone8
        case "iPhone10,2", "iPhone10,5":                return .iPhone8Plus
            
        case "iPhone10,3", "iPhone10,6":                return .iPhoneX
        case "iPhone11,2":                              return .iPhoneXs
        case "iPhone11,4", "iPhone11,6":                return .iPhoneXsMax
        case "iPhone11,8":                              return .iPhoneXr
        default:                                        return .other
        }
    }
    
    // Devices important to the App
    public enum DeviceModelName: String {
        case iPhone5s, iPhone6, iPhone6Plus                 // Low processing power
        case iPhone6s, iPhone6sPlus, iPhoneSE               // midLow processing power
        case iPhone7, iPhone7Plus, iPhone8, iPhone8Plus     // midHigh processing power
        case iPhoneX, iPhoneXs, iPhoneXsMax, iPhoneXr       // high processing power
        case other                                          // Not available
        
    }
    
    public var processingPower: ProcessingRank {
        switch modelName {
        case .iPhone5s, .iPhone6, .iPhone6Plus:
            return ProcessingRank.low
        case .iPhone6s, .iPhone6sPlus, .iPhoneSE:
            return ProcessingRank.midLow
        case .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus:
            return ProcessingRank.midHigh
        case .iPhoneX, .iPhoneXs, .iPhoneXsMax, .iPhoneXr:
            return ProcessingRank.high
        case .other:
            return .unRanked
        }
    }
    
    public enum ProcessingRank: String {
        case low, midLow, midHigh, high, unRanked
        
    }
    
    public var  processingPowerKeywordsAndSynonymsLimit: Int {
        switch processingPower {
        case .low:
            return 30
        case .midLow:
            return 50
        case .midHigh:
            return 80
        case .high, .unRanked:
            return 100
        }
    }
    
    
}
