//
//  Reachability.swift
//  FawGen
//
//  Created by Erick Olibo on 01/07/2019.
//  Copyright © 2019 DEFKUT Creations OU. All rights reserved.
//

import Foundation
import SystemConfiguration

class Reachability {
    
    // Properties
    let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    var flags = SCNetworkReachabilityFlags()
    
    public enum ConnectionType: String {
        case unavailable
        case wifi
        case mobileData
    }

    private func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
    
    public func networkStatus() -> ConnectionType {
        SCNetworkReachabilityGetFlags(reachability!, &flags)
        if !isNetworkReachable(with: flags) {
            return .unavailable
        }
        
        #if os(iOS)
        if flags.contains(.isWWAN) {
            return .mobileData
        }
        #endif
        
        
        return .wifi
    }
    
    
}
